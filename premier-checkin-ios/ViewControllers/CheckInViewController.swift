//
//  CheckInViewController.swift
//  premier-checkin-ios
//
//  Created by Elie El Khoury on 10/6/18.
//  Copyright © 2018 Elie El Khoury. All rights reserved.
//

import UIKit

class CheckInViewController: UIViewController, KeyboardDelegate {

    // MARK: - Outlets
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize custom keyboard
        let keyboardView = Keyboard(frame: CGRect(x: 0, y: 0, width: 0, height: 390))
        keyboardView.delegate = self
        
        // replace system keyboard with custom keyboard
        textField.inputView = keyboardView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
    
    // MARK: - KeyboardDelegate
    
    func keyWasTapped(character: String) {
        textField.insertText(character)
    }
    
    func backspaceTapped() {
        textField.deleteBackward()
    }
    
    func searchTapped() {
        //TODO: perform search then Segue
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

}
