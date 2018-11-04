//
//  NetworkManager.swift
//  premier-checkin-ios
//
//  Created by Elie El Khoury on 11/4/18.
//  Copyright © 2018 Elie El Khoury. All rights reserved.
//

import UIKit
import SVProgressHUD

extension UIViewController {
    
    func get<T : Decodable>(url: String, completion: @escaping (T) -> ()) {
        
        let url = URL(string: url)
        
        SVProgressHUD.show()
        // UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
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
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//        request.setValue("application/form-data", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else { return }
        request.httpBody = httpBody
        
        SVProgressHUD.show()
        //        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            print("\n \n REQUEST: \n \n", request.httpMethod!)
            
            SVProgressHUD.dismiss()
            //            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            if let response = response {
                print("\n \n RESPONSE: \n \n", response)
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

