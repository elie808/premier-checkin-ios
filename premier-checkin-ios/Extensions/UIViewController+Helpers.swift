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
        let updateDBAction   = UIAlertAction(title: "Refresh Database", style: UIAlertAction.Style.default)  { (action) in self.downloadDB() }
        let aboutAction     = UIAlertAction(title: "About", style: UIAlertAction.Style.default)     { (action) in self.presentAboutView() }
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

    // MARK: - Alert Controller Actions
    
    func presentAboutView() {
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
        
        if DBManager.cacheEmpty() == false {
            message = "You have check-in data that hasn’t been uploaded to the server yet! By clicking continue you will lose that data. Enter the event admin code to delete all data."
        } else {
            message = "All your data for the current event will be deleted. Enter the event admin code to delete all data."
        }
        
        show(adminCode: message, title: "Enter admin code") { (AdminCode) in
            
            if (AdminCode == deleteCode) {
                Defaults.clearLastSyncDate()
                Defaults.clearEventCode()
                DBManager.emptyDB()
                self.showEventViewController()
            }
        }
    }
    
    // MARK: - Top Banner
    
    enum BannerMessage : String {
        case CheckinSuccess = "Participant(s) succesfully checked-in"
        case CachingSuccess = "Could not reach server. Check-in saved on device"
        case CacheSyncSuccess = "Check-ins successfully uploaded to server"
        case DBRefreshSuccess = "Database successfully updated"
    }
    
    func showBanner(message : BannerMessage) {
        
        var title = "Success"
        var image = UIImage(named: "checkmark_icon")
        
        switch message {
            
        case .CheckinSuccess:
            image = UIImage(named: "banner_checkmark")

        case .CachingSuccess:
            title = "Info"
            image = UIImage(named: "banner_cache")
            
        case .CacheSyncSuccess:
            title = "Info"
            image = UIImage(named: "banner_sync")

        case .DBRefreshSuccess:
            image = UIImage(named: "banner_download")
        }
        
        let banner = Banner(title: title, subtitle: message.rawValue, image: image, backgroundColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1) )
//        banner.detailLabel.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
        banner.titleLabel.textColor = #colorLiteral(red: 0.4973498583, green: 0.7919111848, blue: 0.1769197583, alpha: 1)
        banner.dismissesOnTap = true
        banner.show(duration: 2.4)
    }
    
    // MARK: - Helpers
    
    /// perform POST. Remove updated objects from cache. Update local DB with successfully returned objects
    func postCheckinData(_ postData: [SyncObject]) {
        
        // POST when there's data
        if postData.isEmpty == false && postData.count > 0 {
            
            var dictArray : [Any] = []
            for syncObj in postData {
                dictArray.append(syncObj.convertToDict())
            }
            
            let params = ["data" : dictArray]
            
            DBManager.addToCache(postData)
            
            NetworkManager.post(url: NetworkingConstants.syncURL, parameterDictionary: params, completion: { (response:Checkin) in
                
                print("\n \n Updates")
                response.updates.forEach() { print($0) }
                print("Errors")
                response.errors.forEach() { print($0) }
                
                // remove from cache all the returned objects (success/error)
                var removeFromCacheData : [SyncObject] = []
                removeFromCacheData.append(contentsOf: response.updates)
                removeFromCacheData.append(contentsOf: response.errors)
                
                // update DB with the successfully processed records
                var updateDBData : [SyncObject] = []
                updateDBData.append(contentsOf: response.updates)
                
                DispatchQueue.main.async {
                    DBManager.removeFromCache(removeFromCacheData)
                    DBManager.updateDBWithValues(updateDBData)
                    self.showBanner(message: .CheckinSuccess)
                    _ = self.navigationController?.popViewController(animated: true)
                }
                
            }) { (error) in
                switch error {
                    
                case .NetworkError:
                    
                    DispatchQueue.main.async {
                        self.showBanner(message: .CachingSuccess)
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                    
                default: return
                }
            }
        }
    }
    
    /// upload all records from cache to server
    func syncData() {
        
        NetworkManager.uploadCacheContent { (syncError) in
            
            if let error = syncError {
                
                switch error {
                    
                case .NetworkError:
                    DispatchQueue.main.async {
                        self.show(alert: "Error", message: "Failed to reach server. Cached check-ins will be kept on device.", buttonTitle: "Ok", onSuccess:nil)
                    }
                    
                default: return
                }
            
            } else {
                DispatchQueue.main.async {
                    self.showBanner(message: .CacheSyncSuccess)
                }
            }
        }
    }
    
    /// download a fresh copy of the DB
    func downloadDB() {

        NetworkManager.get(url: NetworkingConstants.eventURL, completion: { (event:Event) in
            
            DispatchQueue.main.async {
                
                DBManager.emptyDB()
                
                let realm = try! Realm()
                try! realm.write {
                    realm.add(event)
                }
                
                self.showBanner(message: .DBRefreshSuccess)
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
