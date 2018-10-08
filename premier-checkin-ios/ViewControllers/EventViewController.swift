//
//  EventViewController.swift
//  premier-checkin-ios
//
//  Created by Elie El Khoury on 10/7/18.
//  Copyright © 2018 Elie El Khoury. All rights reserved.
//

import UIKit

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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
        
//        show(alert: "Error", message: "Incorrect event code", buttonTitle: "Try again", onSuccess: {
//            print("Trying again")
//        })
    }
    
    // MARK: - Actions
    
    @IBAction func didTapSettings(_ sender: UIBarButtonItem) {
        present(settingsAlertController(), animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case Segue.Event.toCheckinNVC:
            print("checkin")
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
        performSegue(withIdentifier: Segue.Event.toCheckinNVC, sender: nil)
    }
}
