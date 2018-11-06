//
//  CheckInViewController.swift
//  premier-checkin-ios
//
//  Created by Elie El Khoury on 10/6/18.
//  Copyright © 2018 Elie El Khoury. All rights reserved.
//

import UIKit
import RealmSwift

class CheckInViewController: UIViewController {

    enum FeedbackMessage: String {
        case Empty   = ""
        case Failed  = "Not found. Try again ..."
        case Success = "0000 Checked in"
        case Synced  = "Sync Complete"
        case DataDeleted = "App data deleted"
        case EmptyText = "Enter a participant's number"
        case UserNotFound = "Participant not found"
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize custom keyboard & replace system keyboard with custom keyboard
        let keyboardView = Keyboard(frame: CGRect(x: 0, y: 0, width: 0, height: 390))
        keyboardView.delegate = self
        textField.inputView = keyboardView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        messageLabel.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
    
    // MARK: - Helpers
    
    func showSuccess(message : String) {
        messageLabel.textColor = UIColor.green
        messageLabel.text = message
    }
    
    func showError(message : String) {
        messageLabel.textColor = UIColor.red
        messageLabel.text = message
    }
    
    func checkDBForParticipant() {
        
        if let regID = textField.text {
            if regID.count > 0 {
                if let result = searchDB(forID: regID) {
                    if result is ETicket {
                        performSegue(withIdentifier: Segue.Checkin.toGroupCheckinVC, sender: nil)
                    } else {
                        performSegue(withIdentifier: Segue.Checkin.toParticipantCheckinVC, sender: nil)
                    }
                } else {
                    showError(message: FeedbackMessage.UserNotFound.rawValue)
                }
            } else {
                showError(message: FeedbackMessage.EmptyText.rawValue)
            }
        }
    }
    
    func searchDB(forID regID : String) -> Any? {
        
        let realm = try! Realm()
        
        let tTicketPrefix = "T" + regID
        let tPredicate = NSPredicate(format: "reg_id = %@", tTicketPrefix) // only used for t_tickets
        let predicate = NSPredicate(format: "reg_id = %@", regID) // used for the other tickets
        
        let tTickets = realm.objects(TTicket.self).filter(tPredicate)
        
        if tTickets.isEmpty == true {
            
            let eTickets = realm.objects(ETicket.self).filter(predicate)
            
            if eTickets.isEmpty == true {
                
                let iTickets = realm.objects(ITicket.self).filter(predicate)
                
                if iTickets.isEmpty == true {
                    return nil
                } else {
                    return iTickets.first
                }
                
            } else {
                return eTickets.first
            }
            
        } else {
            return tTickets.first
        }
    }
    
    // MARK: - Actions
    
    @IBAction func didTapSettings(_ sender: UIBarButtonItem) {
        present(settingsAlertController(), animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {

        case Segue.Checkin.toGroupCheckinVC:
            let vc : GroupCheckInViewController = segue.destination as! GroupCheckInViewController
            vc.title = "Premiere Checkin (30)"
            
        case Segue.Checkin.toParticipantCheckinVC:
            let vc : SingleCheckinViewController = segue.destination as! SingleCheckinViewController
            vc.title = "Premiere Checkin"
            
        default: return
        }
    }
}

// MARK: - KeyboardDelegate

extension CheckInViewController : KeyboardDelegate {
    
    func keyWasTapped(character: String) {
        messageLabel.text = ""
        textField.insertText(character)
    }
    
    func backspaceTapped() {
        messageLabel.text = ""
        textField.deleteBackward()
    }
    
    func searchTapped() {
        checkDBForParticipant()
    }
}
