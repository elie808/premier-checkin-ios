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
        
        let alertController = UIAlertController(title: "Last sync: Today 02:53PM", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let syncNowAction   = UIAlertAction(title: "Sync Now", style: UIAlertAction.Style.default)  { (action) in self.syncData() }
        let aboutAction     = UIAlertAction(title: "About", style: UIAlertAction.Style.default)     { (action) in self.showAbout() }
        let eventPageAction = UIAlertAction(title: "Event Page", style: UIAlertAction.Style.default) { (action) in self.showEventWebPageViewController() }
        let deleteEventAction = UIAlertAction(title: "Delete Event Data", style: UIAlertAction.Style.destructive) { (action) in self.deleteData() }
        let cancelAction    = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        alertController.addAction(syncNowAction)
        alertController.addAction(aboutAction)
        alertController.addAction(eventPageAction)
        alertController.addAction(deleteEventAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    func syncData() {
        print("Sync")
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
        vc.URLString = "https://www.premieronline.com/event/walkon2018"
        vc.title = "Event"
        present(navigationCtrl, animated: true, completion: nil)
    }
    
    func showEventViewController() {
        let storyBoard : UIStoryboard = UIStoryboard.Main
        let navigationCtrl = storyBoard.instantiateViewController(withIdentifier: ViewControllerStoryboardIdentifier.EventNVC.rawValue) as! UINavigationController
//        let vc = navigationCtrl.children[0] as! EventViewController
        present(navigationCtrl, animated: true, completion: nil)
    }
    
    func deleteData() {
        
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
                self.emptyDB()
                self.showEventViewController()
            }
        }
    }
    
    func emptyDB() {
        
        let realmURL = Realm.Configuration.defaultConfiguration.fileURL!
        let realmURLs = [realmURL, realmURL.appendingPathExtension("lock"), realmURL.appendingPathExtension("note"), realmURL.appendingPathExtension("management") ]

        for URL in realmURLs {
            do {
                try FileManager.default.removeItem(at: URL)
            } catch {
                // handle error
            }
        }
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
}
