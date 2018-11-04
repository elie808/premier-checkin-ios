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
        
        //TODO: Remove after testing
        textField.text = "3796204"
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
        
        guard let eventCode = textField.text  else { return }
        
//        //TODO: Get from UserDefaults
//        let secret = "ZnX59SzKHgzuYuVjoE5s"
//        let info = ""//"optionaltexthere"
//
//        let urlString = "https://www.premieronline.com/webservice/checkin/index.php?secret=\(secret)&code=\(eventCode)&info=\(info)"
//
//        get(url: urlString) { (event : Event_z) in
//
//            print(event.url_logo)
//
////            TODO: needs to be performed on main thread
////             self.performSegue(withIdentifier: Segue.Event.toCheckinNVC, sender: nil)
//         }
//
//
//        // Use them like regular Swift objects
//        let myDog = Event_z()
//        myDog.url_logo = "Rex"
//        print("name of dog: \(myDog.url_logo)")
//
//        // Get the default Realm
//        let realm = try! Realm()
//
//        // Persist your data easily
////        try! realm.write {
////            realm.add(myDog)
////        }
        
    }
}

//class Event_z: Decodable {
//    var url_logo : String = ""
//    var tickets : [QuantumValue] = []
//}
//
//class companyTicket: Object, Decodable {
//    @objc dynamic var reg_id : String = ""
//    @objc dynamic var sync_id : String = ""
//    @objc dynamic var company : String = ""
//}
//
//class singleTicket: Object, Decodable {
//    @objc dynamic var reg_id : String = ""
//    @objc dynamic var sync_id : String = ""
//    @objc dynamic var age : String = ""
//}
//
//
//enum QuantumValue: Decodable {
//
//    case companyTx(companyTicket), singleTx(singleTicket)
//
//    init(from decoder: Decoder) throws {
//
//        if let companyTx = try? decoder.singleValueContainer().decode(companyTicket.self) {
//            self = .companyTx(companyTx)
//            return
//        }
//
//        if let singleTx = try? decoder.singleValueContainer().decode(singleTicket.self) {
//            self = .singleTx(singleTx)
//            return
//        }
//
//        throw QuantumError.missingValue
//    }
//
//    enum QuantumError:Error {
//        case missingValue
//    }
//}

