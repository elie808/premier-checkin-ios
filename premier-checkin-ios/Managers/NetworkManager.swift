//
//  NetworkManager.swift
//  premier-checkin-ios
//
//  Created by Elie El Khoury on 11/4/18.
//  Copyright © 2018 Elie El Khoury. All rights reserved.
//

import UIKit
import RealmSwift
import SVProgressHUD

enum FeedbackMessage: String {
    case Empty   = ""
    case Failed  = "Not found. Try again ..."
    case Success = "0000 Checked in"
    case Synced  = "Sync Complete"
    case DataDeleted = "App data deleted"
    case EmptyText = "Enter a participant's number"
    case UserNotFound = "Participant not found"
    case UserAlreadyCheckedin = "Participant already checked in"
    case CheckinLimitExceeded = "Check in limit reached"
}

//struct Errors : Decodable {
//    var response_code : String
//    var response_message : String
//    var error : String
//}

enum Errors {
    case NotFound
    case AlreadyCheckedIn
    case WrongID
    case JSONError
    case NetworkError
}

extension UIViewController {
    
    func get<T : Decodable>(url: String, completion: @escaping (T) -> (), errors: @escaping (Errors) -> ()) {
        
        let url = URL(string: url)
        
        SVProgressHUD.show()
        DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = true }
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            SVProgressHUD.dismiss()
            DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = false }
            
            if let err = error {
                print("Network Error: ", err)
                errors(.NetworkError)
            }
            
            guard let data = data else { return }
            
            if let resp : HTTPURLResponse = response as? HTTPURLResponse {
                
                switch resp.statusCode {
                    
                case 200:
                    do {
                        
                        let response = try JSONDecoder().decode(T.self, from: data)
                        completion(response)
                        
                    } catch let error {
                        
                        print("\n ERROR DECODING: ", error)
                        errors(.JSONError)
                    }
                    
                case 401:
                    errors(.NotFound)
                    
                default: return
                }
            }
            }.resume()
    }
    
    func post<T : Codable>(url: String, parameterDictionary : [String:Any], completion: @escaping (T) -> (), errors: @escaping (Errors) -> ()) {
        
        guard let serviceUrl = URL(string: url) else { return }
        
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else { return }
        request.httpBody = httpBody
        
        SVProgressHUD.show()
        DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = true }

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            SVProgressHUD.dismiss()
            DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = false }
            
            if let err = error {
                print("Network Error: ", err)
                errors(.NetworkError)
            }

            guard let data = data else { return }
            
            if let resp : HTTPURLResponse = response as? HTTPURLResponse {
                switch resp.statusCode {
                    
                case 200:
                    do {
                        
                        let response = try JSONDecoder().decode(T.self, from: data)
                        completion(response)
                        
                    } catch let error {
                        
                        print("\n ERROR DECODING: ", error)
                        errors(.JSONError)
                    }
                    
                case 204:
                    errors(.AlreadyCheckedIn)
                    
                case 404:
                    errors(.WrongID)
                    
                default: return
                }
            }
            }.resume()
    }

}

