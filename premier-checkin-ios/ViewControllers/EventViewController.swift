//
//  EventViewController.swift
//  premier-checkin-ios
//
//  Created by Elie El Khoury on 10/7/18.
//  Copyright © 2018 Elie El Khoury. All rights reserved.
//

import UIKit
import SVProgressHUD
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
        
        post()
        /*
        guard let eventCode = textField.text  else { return }
        
        //TODO: Get from UserDefaults
        let secret = "ZnX59SzKHgzuYuVjoE5s"
        let info = ""//"optionaltexthere"
        
        let urlString = "https://www.premieronline.com/webservice/checkin/index.php?secret=\(secret)&code=\(eventCode)&info=\(info)"

        get(url: urlString) { (event : Event_z) in
        
            print(event.url_logo)
            
//            TODO: needs to be performed on main thread
//             self.performSegue(withIdentifier: Segue.Event.toCheckinNVC, sender: nil)
         }
        
        
        // Use them like regular Swift objects
        let myDog = Event_z()
        myDog.url_logo = "Rex"
        print("name of dog: \(myDog.url_logo)")
        
        // Get the default Realm
        let realm = try! Realm()
        
        // Persist your data easily
//        try! realm.write {
//            realm.add(myDog)
//        }
         
         */
    }
}

class Event_z: Object, Decodable {
    @objc dynamic var url_logo : String = ""
}

// MARK: - Networking

extension EventViewController {
    
    func get<T : Decodable>(url: String, completion: @escaping (T) -> ()) {

        let url = URL(string: url)
        
        SVProgressHUD.show()
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
        
            SVProgressHUD.dismiss()
            //TODO: Perform on main thread
            // UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            if let resp : HTTPURLResponse = response as? HTTPURLResponse {
                print("\n \n \n \n RESPONSE ", resp.statusCode)
            }
            
            if let err = error {
                print("errorrrr: ", err)
            }
            
            guard let data = data else { return }
            
            do {
                
                let feed = try JSONDecoder().decode(T.self, from: data)
                completion(feed) 
                
            } catch let jsonError {
                
                print("Failed to decode JSON: ", jsonError)
            }
            
            }.resume()
    }
    
    
    func post() {
        
        let secret = "ZnX59SzKHgzuYuVjoE5s"
        let eventCode = "3796204"
        
        let Url = "https://www.premieronline.com/webservice/checkin/index.php?secret=\(secret)&code=\(eventCode)"
        
        guard let serviceUrl = URL(string: Url) else { return }
        
        
        
        let dict1 = ["sync_id": "t2", "quantity": "1", "checkin_date": ""]
        let dict2 = ["sync_id": "e2236744", "quantity": "20", "checkin_date": "1541073901"]
        
        let parameterDictionary = ["data" : [dict1, dict2] ]
        
//        [
//            {
//                "sync_id": "i695578",
//                "quantity": "1",
//                "checkin_date": ""
//            },
//            {
//
//            }
//        ]
//
//        let jsonObject: [String: Any] = [
//            "type_id": 1,
//            "model_id": 1,
//            "data": [
//                "startDate": "10/04/2015 12:45",
//                "endDate": "10/04/2015 16:00"
//            ],
//            "custom": savedData
//        ]
        
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
//        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else { return }
        request.httpBody = httpBody
        
        SVProgressHUD.show()
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            SVProgressHUD.dismiss()
//            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            if let response = response {
                print("\n \n RESPONSE: \n", response)
            }
            
            if let data = data {
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print("\n \n JSON: \n", json)
                    
                } catch {
                    print(error)
                }
            }
            }.resume()
    }
    
}
