//
//  CheckInViewController.swift
//  premier-checkin-ios
//
//  Created by Elie El Khoury on 10/6/18.
//  Copyright © 2018 Elie El Khoury. All rights reserved.
//

import UIKit
import RealmSwift
import Reachability

class CheckInViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        textField.text = "761412"
        
        // initialize custom keyboard & replace system keyboard with custom keyboard
        let keyboardView = Keyboard(frame: CGRect(x: 0, y: 0, width: 0, height: 390))
        keyboardView.delegate = self
        textField.inputView = keyboardView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        messageLabel.text = ""
        textField.text = ""
        

    }
    

    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
    
    // MARK: - Actions
    
    @IBAction func didTapSettings(_ sender: UIBarButtonItem) {
        present(settingsAlertController(), animated: true, completion: nil)
    }
    
    @IBAction func didTapSTicketsButton(_ sender : UIButton) {
        
        // Ghetto workaround
        let realm = try! Realm()
        
        if let sTicket = realm.objects(STicket.self).first {
            performSegue(withIdentifier: Segue.Checkin.toSpecialGroupCheckinVC, sender: sTicket)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {

        case Segue.Checkin.toSpecialGroupCheckinVC:
            let vc : GroupCheckInViewController = segue.destination as! GroupCheckInViewController
            if let ticket = sender {
                if ticket is STicket {
                    vc.title = "Premiere Checkin"
                    vc.passedSTicket = ticket as? STicket
                }
            }
            
        case Segue.Checkin.toGroupCheckinVC:
            let vc : GroupCheckInViewController = segue.destination as! GroupCheckInViewController
            if let ticket = sender {
                if ticket is ETicket {
                    vc.title = "Premiere Checkin"
                    vc.passedETicket = ticket as? ETicket
                }
            }
            
        case Segue.Checkin.toParticipantCheckinVC:
            let vc : SingleCheckinViewController = segue.destination as! SingleCheckinViewController
            if let ticket = sender {
                if (ticket is ITicket) {
                    vc.title = "Premiere Checkin"
                    vc.passedITicket = ticket as? ITicket
                } else if (ticket is TTicket) {
                    vc.passedTTicket = ticket as? TTicket
                }
            }
            
        default: return
        }
    }
}

// MARK: - Helpers

extension CheckInViewController {
    
    func showSuccess(message : String) {
        messageLabel.textColor = UIColor.green
        messageLabel.text = message
    }
    
    func showError(message : String) {
        messageLabel.textColor = UIColor.red
        messageLabel.text = message
    }
    
    /// search DB if participant exists
    func checkDBForParticipant(with regID : String) {
        if regID.count > 0 {
            if let result = searchDB(forID: regID) {
                
                switch result {
                    
                case is ETicket:
                    if ( ((result as! ETicket).adult?.checkins_pending)! > 0 ) || (((result as! ETicket).child?.checkins_pending)! > 0) {
                        performSegue(withIdentifier: Segue.Checkin.toGroupCheckinVC, sender: result)
                    } else {
                        showError(message: FeedbackMessage.CheckinLimitExceeded.rawValue)
                    }
                
                case is STicket:
                    if (result as! STicket).checkins_pending > 0 {
                        performSegue(withIdentifier: Segue.Checkin.toSpecialGroupCheckinVC, sender: result)
                    } else {
                        showError(message: FeedbackMessage.CheckinLimitExceeded.rawValue)
                    }
                
                case is TTicket:
                    if (result as! TTicket).checkins_pending > 0 {
                        performSegue(withIdentifier: Segue.Checkin.toParticipantCheckinVC, sender: result)
                    } else {
                        showError(message: FeedbackMessage.UserAlreadyCheckedin.rawValue)
                    }
                
                case is ITicket:
                    if (result as! ITicket).checkins_pending > 0 {
                        performSegue(withIdentifier: Segue.Checkin.toParticipantCheckinVC, sender: result)
                    } else {
                        showError(message: FeedbackMessage.UserAlreadyCheckedin.rawValue)
                    }
                    
                default:
                    showError(message: FeedbackMessage.Failed.rawValue)
                }

            } else {
                showError(message: FeedbackMessage.UserNotFound.rawValue)
            }
        } else {
            showError(message: FeedbackMessage.EmptyText.rawValue)
        }
    }

}

extension CheckInViewController : UITextFieldDelegate {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        messageLabel.text = ""
        return true
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
        if let regID = textField.text {
            checkDBForParticipant(with: regID)
        }
    }
}
