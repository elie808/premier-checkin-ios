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
}

struct Errors : Decodable {
    var response_code : String
    var response_message : String
    var error : String
}

extension UIViewController {
    
    func get<T : Decodable>(url: String, completion: @escaping (T) -> (), errorz: @escaping (Errors) -> ()) {
        
        let url = URL(string: url)
        
        SVProgressHUD.show()
        // UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            SVProgressHUD.dismiss()
            //TODO: Perform on main thread
            // UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            if let resp : HTTPURLResponse = response as? HTTPURLResponse {
                print("\n \n \n \n STATUS CODE ", resp.statusCode)
            }
            
            if let err = error {
                print("errorrrr: ", err)
            }
            
            guard let data = data else { return }
            
            guard let response = try? JSONDecoder().decode(T.self, from: data) else {
                
                // TODO: needs fixing
                if let erResp = try? JSONDecoder().decode(Errors.self, from: data) {
                    errorz(erResp)
                }
                
                return
            }

            completion(response)
            
            }.resume()
    }
    
    func getPostString(params:[String:Any]) -> String
    {
        var data = [String]()
        for(key, value) in params
        {
            data.append(key + "=\(value)")
        }
        return data.map { String($0) }.joined(separator: "&")
    }
    
    func post<T : Codable>(url: String, parameterDictionary : [String:Any], completion: @escaping (T) -> ()) {
        
        guard let serviceUrl = URL(string: url) else { return }
        
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("application/form-data", forHTTPHeaderField: "Content-Type")
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else { return }
        request.httpBody = httpBody
        
        print("\n HTTP BODY: \n", request.httpBody!)
        
        SVProgressHUD.show()
        //        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            print("\n REQUEST: ", request.httpMethod!)
            
            SVProgressHUD.dismiss()
            // UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            if let resp : HTTPURLResponse = response as? HTTPURLResponse {
                print("\n STATUS CODE ", resp.statusCode)
            }
            
            if let data = data {
                do {
                  
                    guard let response = try? JSONDecoder().decode(T.self, from: data) else {
                        print("\n \n ERROR DECODING: ", data)
                        return
                    }

//                    let json = try JSONDecoder().decode(T.self, from: data)
//                    print("\n \n JSON: \n", json)
                    
                    completion(response)
                    
                } catch {
                    print(error)
                }
            }
            }.resume()
    }

    //------ DB STuff
    
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
    
    
}

