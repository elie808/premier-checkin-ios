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

enum Errors {
    case NotFound
    case AlreadyCheckedIn
    case WrongID
    case JSONError
    case NetworkError
}

struct NetworkingConstants {
    
    private struct Domains {
        static let baseURL = "https://www.premieronline.com/"
    }
    
    private struct Routes {
        static let index = "webservice/checkin/index.php"
        static let sync = "webservice/checkin/sync.php"
        static let about = "event/walkon2018"
    }
    
    private struct Credentials {
        static let code = "code=\(Defaults.eventCode)"
        static let secret = "secret=\(Defaults.appSecret)"
        
        static let credentials = "?\(Credentials.code)&\(Credentials.secret)"
    }
    
    static let eventURL = Domains.baseURL + Routes.index + Credentials.credentials
    static let syncURL  = Domains.baseURL + Routes.sync + Credentials.credentials
    static let aboutURL = Domains.baseURL + Routes.about
}

class NetworkManager {
    
    // MARK: - REST
    
    class func get<T : Decodable>(url: String, completion: @escaping (T) -> (), errors: @escaping (Errors) -> ()) {
        
        let url = URL(string: url)
        
        SVProgressHUD.show()
        DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = true }
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            SVProgressHUD.dismiss()
            DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = false }
            
            if let err = error {
                print("Network Error: ", err)
                errors(.NetworkError)
                return
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
    
    class func post<T : Codable>(url: String, parameterDictionary : [String:Any], completion: @escaping (T) -> (), errors: @escaping (Errors) -> ()) {
        
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
                return
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
    
    // MARK: - Helpers
    
    /// upload  cache content then empty it on success
    class func uploadCacheContent(errors: @escaping (Errors?) -> ()) {
        
        let realm = try! Realm()
        let cachedObjects = realm.objects(SyncObject.self)
        
        if cachedObjects.isEmpty == false && cachedObjects.count > 0 {
            
            Defaults.setCacheEmpty(flag: false)
            
            var dictArray : [Any] = []
            for syncObj in cachedObjects {
                dictArray.append(syncObj.convertToDict())
            }
            
            let params = ["data" : dictArray]
            
            post(url: NetworkingConstants.syncURL, parameterDictionary: params, completion: { (response : Checkin) in
                
                // remove from cache all the returned objects (success/error)
                var removeFromCacheData : [SyncObject] = []
                removeFromCacheData.append(contentsOf: response.updates)
                removeFromCacheData.append(contentsOf: response.errors)
                
                DispatchQueue.main.async {
                    DBManager.updateDBWithValues(response.updates)
                    DBManager.emptyCache()
                    Defaults.saveLastSyncDate()
                    Defaults.setCacheEmpty(flag: true)
                }
                
                errors(nil)
                
            }) { (error) in
                
                errors(error)
            }
        
        } else {
            
            Defaults.setCacheEmpty(flag: true)
        }
    }
    
}

