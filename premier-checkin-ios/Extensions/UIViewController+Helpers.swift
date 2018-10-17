//
//  UIViewController+Helpers.swift
//  premier-checkin-ios
//
//  Created by Elie El Khoury on 10/6/18.
//  Copyright © 2018 Elie El Khoury. All rights reserved.
//

import UIKit

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
        let eventPageAction = UIAlertAction(title: "Event Page", style: UIAlertAction.Style.default) { (action) in self.showEventViewController() }
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
        let storyBoard : UIStoryboard = UIStoryboard.Main
        let navigationCtrl = storyBoard.instantiateViewController(withIdentifier: ViewControllerStoryboardIdentifier.WebNVC.rawValue) as! UINavigationController
        let vc = navigationCtrl.children[0] as! WebViewController
        vc.URLString = "https://www.google.com"
        vc.title = "About"
        present(navigationCtrl, animated: true, completion: nil)
    }
    
    func showEventViewController() {
        let storyBoard : UIStoryboard = UIStoryboard.Main
        let navigationCtrl = storyBoard.instantiateViewController(withIdentifier: ViewControllerStoryboardIdentifier.WebNVC.rawValue) as! UINavigationController
        let vc = navigationCtrl.children[0] as! WebViewController
        vc.URLString = "https://www.apple.com"
        vc.title = "Event"
        present(navigationCtrl, animated: true, completion: nil)
    }
    
    func deleteData() {

        show(adminCode: "Enter the event admin code to delete the app check in data", title: "Enter admin code") { (AdminCode) in
            print(AdminCode)
            
//            let unsyncedData = false

//            if unsyncedData == true {
            
//                self.show(twoButtonAlert: "Warning",
//                          message: "You have Check-in Data that hasn’t been uploaded to the server. By clicking continue you will lose that data",
//                          buttonOneTitle: "Back", buttonTwoTitle: "Continue",
//                          onConfirm: nil, onCancel: nil)
                
//            } else {
            
                self.show(twoButtonAlert: "Warning",
                          message: "Your data for the current event will be deleted.",
                          buttonOneTitle: "Back", buttonTwoTitle: "Delete",
                          onConfirm: nil, onCancel: nil)
//            }
        }
        
    }
    
    func show(adminCode message:String, title:String,
              onSuccess success: ((_ adminCode: String) -> Void)?) {
        
        let actionSheet : UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        actionSheet.addTextField { (textField) in
            textField.placeholder = "Admin code"
        }
        
        actionSheet.addAction(UIAlertAction(title: "Back", style: .default, handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "Continue", style: .destructive, handler: { (action) in
            
            if (actionSheet.textFields?.count)! > 0 {
                
                let adminCodeTextField = actionSheet.textFields?.first
                
                if (adminCodeTextField?.text?.count)! > 0 {
                    print((adminCodeTextField?.text)!)
                    
                    guard let successClosure = success else { return }
                    successClosure((adminCodeTextField?.text)!)
                }
            }
        }))
        
        present(actionSheet, animated: true, completion: nil)
    }
}
