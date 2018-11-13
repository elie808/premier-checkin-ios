//
//  UIViewController+Helpers.swift
//  premier-checkin-ios
//
//  Created by Elie El Khoury on 10/6/18.
//  Copyright © 2018 Elie El Khoury. All rights reserved.
//

import UIKit
import RealmSwift

extension UIViewController {
    
    // MARK: - AlertControllers
    
    func show(alert title:String, message:String, buttonTitle:String, onSuccess success: (() -> Void)?)  {
        
        let actionSheet : UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        actionSheet.addAction(UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default, handler: { (action) in
            guard let successClosure = success else { return }
            successClosure()
        }))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func show(twoButtonAlert title:String, message:String, buttonOneTitle:String, buttonTwoTitle:String, onConfirm confirm:(() -> Void)?,
              onCancel cancel: (() -> Void)?)  {
        
        let actionSheet : UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        actionSheet.addAction(UIAlertAction(title: buttonOneTitle, style: .default, handler: { (action) in
            guard let confirmClosure = confirm else { return }
            confirmClosure()
        }))
        
        actionSheet.addAction(UIAlertAction(title: buttonTwoTitle, style: .destructive, handler: { (action) in
            guard let cancelClosure = cancel else { return }
            cancelClosure()
        }))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    // MARK: - Settings Alert Controller
    
    func settingsAlertController() -> UIAlertController {
        
        let alertController = UIAlertController(title: "Last sync: \(Defaults.lastSyncDate)", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let syncNowAction   = UIAlertAction(title: "Sync Now", style: UIAlertAction.Style.default)  { (action) in self.syncData() }
        let updateDBAction   = UIAlertAction(title: "Update Database", style: UIAlertAction.Style.default)  { (action) in self.updateDB() }
        let aboutAction     = UIAlertAction(title: "About", style: UIAlertAction.Style.default)     { (action) in self.showAbout() }
        let eventPageAction = UIAlertAction(title: "Event Page", style: UIAlertAction.Style.default) { (action) in self.showEventWebPageViewController() }
        let deleteEventAction = UIAlertAction(title: "Delete Event Data", style: UIAlertAction.Style.destructive) { (action) in self.showDeleteData() }
        let cancelAction    = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        alertController.addAction(syncNowAction)
        alertController.addAction(updateDBAction)
        alertController.addAction(aboutAction)
        alertController.addAction(eventPageAction)
        alertController.addAction(deleteEventAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }

    func showAbout() {
        let storyBoard : UIStoryboard = UIStoryboard.Support
        let navigationCtrl = storyBoard.instantiateViewController(withIdentifier: ViewControllerStoryboardIdentifier.AboutNVC.rawValue) as! UINavigationController
        let vc = navigationCtrl.children[0] as! AboutViewController
        vc.title = "About"
        present(navigationCtrl, animated: true, completion: nil)
    }
    
    func showEventWebPageViewController() {
        let storyBoard : UIStoryboard = UIStoryboard.Support
        let navigationCtrl = storyBoard.instantiateViewController(withIdentifier: ViewControllerStoryboardIdentifier.WebNVC.rawValue) as! UINavigationController
        let vc = navigationCtrl.children[0] as! WebViewController
        vc.URLString = NetworkingConstants.aboutURL
        vc.title = "Event"
        present(navigationCtrl, animated: true, completion: nil)
    }
    
    func showEventViewController() {
        let storyBoard : UIStoryboard = UIStoryboard.Main
        let navigationCtrl = storyBoard.instantiateViewController(withIdentifier: ViewControllerStoryboardIdentifier.EventNVC.rawValue) as! UINavigationController
//        let vc = navigationCtrl.children[0] as! EventViewController
        present(navigationCtrl, animated: true, completion: nil)
    }
    
    func show(adminCode message:String, title:String,
              onSuccess success: ((_ adminCode: String) -> Void)?) {
        
        let actionSheet : UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        actionSheet.addTextField { (textField) in
            textField.placeholder = "Admin code"
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "Continue", style: .destructive, handler: { (action) in
            
            if (actionSheet.textFields?.count)! > 0 {
                
                let adminCodeTextField = actionSheet.textFields?.first
                
                if ( (adminCodeTextField?.text?.count)! > 0 && adminCodeTextField?.text?.isEmpty == false){
                    guard let successClosure = success else { return }
                    successClosure((adminCodeTextField?.text)!)
                }
            }
        }))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func showDeleteData() {
        
        var message = ""
        let realm = try! Realm()
        let deleteCode = realm.objects(Event.self).first?.delete_code
        
        if self.cacheEmpty() == false {
            message = "You have check-in data that hasn’t been uploaded to the server yet! By clicking continue you will lose that data. Enter the event admin code to delete all data."
        } else {
            message = "All your data for the current event will be deleted. Enter the event admin code to delete all data."
        }
        
        show(adminCode: message, title: "Enter admin code") { (AdminCode) in
            
            if (AdminCode == deleteCode) {
                Defaults.clearLastSyncDate()
                Defaults.clearEventCode()
                self.emptyDB()
                self.showEventViewController()
            }
        }
    }
    
    // MARK: DB Helpers
    
    /// upload all records from cache to server
    func syncData() {
                
        let realm = try! Realm()
        let cachedObjects = realm.objects(SyncObject.self)
        
        if cachedObjects.isEmpty == false && cachedObjects.count > 0 {
            
            var dictArray : [Any] = []
            for syncObj in cachedObjects {
                dictArray.append(syncObj.convertToDict())
            }
            
            let params = ["data" : dictArray]
            
            post(url: NetworkingConstants.syncURL, parameterDictionary: params, completion: { (response : Checkin) in
                
                // remove from cache all the returned objects (success/error)
                var removeFromCacheData : [SyncObject] = []
                removeFromCacheData.append(contentsOf: response.updates)
                removeFromCacheData.append(contentsOf: response.errors)
                
                DispatchQueue.main.async {
                    self.updateDBWithValues(response.updates)
                    self.emptyCache()
                    Defaults.saveLastSyncDate()
                }
                
            }) { (error) in
                switch error {
                case .NetworkError:
                    DispatchQueue.main.async {
                        self.show(alert: "Error", message: "Failed to reach server. This check-in will be kept in the local cache.", buttonTitle: "Ok", onSuccess:nil)
                    }
                    
                default: return
                }
            }
            
        } else {
            show(alert: "Warning", message: "Cache is empty. No data to sync :)", buttonTitle: "Ok", onSuccess:nil)
        }
        
    }
    
    func updateDB() {

        get(url: NetworkingConstants.eventURL, completion: { (event:Event) in
            
            DispatchQueue.main.async {
                
                self.emptyDB()
                
                let realm = try! Realm()
                
                try! realm.write {
                    realm.add(event)
                }
            }
            
        }) { (error) in
            
            switch error {
                
            case .NotFound:
                DispatchQueue.main.async {
                    self.show(alert: "Error", message: "Event not found code", buttonTitle: "Ok", onSuccess:nil)
                }
                
            case .NetworkError:
                DispatchQueue.main.async {
                    self.show(alert: "Error", message: "Download failed. You seem to be offline.", buttonTitle: "Ok", onSuccess:nil)
                }
                
            default: return
            }
        }
        
    }
    
}
