//
//  EventViewController.swift
//  premier-checkin-ios
//
//  Created by Elie El Khoury on 10/7/18.
//  Copyright © 2018 Elie El Khoury. All rights reserved.
//

import UIKit
import RealmSwift

class EventViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var textField: UITextField!
    
    // MARK: - Views Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize custom keyboard & replace system keyboard with custom keyboard
        let keyboardView = Keyboard(frame: CGRect(x: 0, y: 0, width: 0, height: 390))
        keyboardView.delegate = self
        textField.inputView = keyboardView
        
//        textField.text = "3796204"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
    
    // MARK: - Actions
    
    @IBAction func didTapSettings(_ sender: UIBarButtonItem) {
        present(settingsAlertController(), animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
//        case Segue.Event.toCheckinNVC:
        default: return
        }
    }
}

// MARK: - KeyboardDelegate

extension EventViewController : KeyboardDelegate {
    
    func keyWasTapped(character: String) {
        textField.insertText(character)
    }
    
    func backspaceTapped() {
        textField.deleteBackward()
    }
    
    func searchTapped() {
        
        guard let eventCode = textField.text  else { return }
         
        get(url: NetworkingConstants.eventURL, completion: { (event:Event) in
            
            DispatchQueue.main.async {
            
                Defaults.saveEventCode(code: eventCode)
                
                let realm = try! Realm()

                try! realm.write {
                    realm.add(event)
                    self.performSegue(withIdentifier: Segue.Event.toCheckinNVC, sender: nil)
                }
            }

        }) { (error) in

            switch error {
                
            case .NotFound:
                DispatchQueue.main.async {
                    self.show(alert: "Error", message: "Incorrect event code", buttonTitle: "Try again", onSuccess:nil)
                }
                
            default: return
            }
        }
    }
    
}

