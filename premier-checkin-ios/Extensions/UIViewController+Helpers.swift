//
//  UIViewController+Helpers.swift
//  premier-checkin-ios
//
//  Created by Elie El Khoury on 10/6/18.
//  Copyright © 2018 Elie El Khoury. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func show(alert title:String, message:String, buttonTitle:String) {
        
        let actionSheet : UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        actionSheet.addAction(UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default, handler: { (action) in
            
        }))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
}
