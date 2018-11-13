//
//  SingleCheckinViewController.swift
//  premier-checkin-ios
//
//  Created by Elie El Khoury on 11/4/18.
//  Copyright © 2018 Elie El Khoury. All rights reserved.
//

import UIKit

class SingleCheckinViewController: UIViewController {

    // MARK: - Properties
    
    var passedTTicket : TTicket?
    var passedITicket : ITicket?
    
    // MARK: - Outlets
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var adultImageView: UIImageView!
    @IBOutlet weak var childImageView: UIImageView!
    
    // MARK: - Views Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    // MARK: - Helpers
    
    func configureView() {
        
        if passedTTicket != nil {
            titleLabel.text = passedTTicket?.title
            adultImageView.image = UIImage(named: "adult_selected")
            childImageView.image = UIImage(named: "child_unselectable")
        }
        
        if let iTicket = passedITicket {
//            titleLabel.text = ""
            if Int(iTicket.age)! > 18 {
                adultImageView.image = UIImage(named: "adult_selected")
                childImageView.image = UIImage(named: "child_unselectable")
            } else {
                adultImageView.image = UIImage(named: "adult_unselectable")
                childImageView.image = UIImage(named: "child_selected")
            }
        }
    
    }
    
    // MARK: - Actions
    
    @IBAction func didTapAccept(_ sender: UIButton) {
        
        var postData : [SyncObject] = []
        var syncID = ""
        let currentTime = Int64(NSDate().timeIntervalSince1970)
       
        if let tTicket = passedTTicket {
            syncID = tTicket.sync_id
        }
 
        if let iTicket = passedITicket {
            syncID = iTicket.sync_id
        }
        
        postData.append(SyncObject(sync_id: syncID, quantity: "1", checkin_date: String(currentTime)))
        
        // POST when there's data
        if postData.isEmpty == false && postData.count > 0 {
            
            var dictArray : [Any] = []
            for syncObj in postData {
                dictArray.append(syncObj.convertToDict())
            }
            
            let params = ["data" : dictArray]
            
            DBManager.addToCache(postData)
            
            NetworkManager.post(url: NetworkingConstants.syncURL, parameterDictionary: params, completion: { (response:Checkin) in
                
                print("\n \n Updates")
                response.updates.forEach() { print($0) }
                print("Errors")
                response.errors.forEach() { print($0) }
                
                // remove from cache all the returned objects (success/error)
                var removeFromCacheData : [SyncObject] = []
                removeFromCacheData.append(contentsOf: response.updates)
                removeFromCacheData.append(contentsOf: response.errors)
                
                // update DB with the successfully processed records
                var updateDBData : [SyncObject] = []
                updateDBData.append(contentsOf: response.updates)
                
                DispatchQueue.main.async {
                    DBManager.removeFromCache(removeFromCacheData)
                    DBManager.updateDBWithValues(updateDBData)
                    Defaults.saveLastSyncDate()
                    _ = self.navigationController?.popViewController(animated: true)
                }
                
            }) { (error) in
                switch error {
                    
                case .NetworkError:
                   
                    DispatchQueue.main.async {
                        self.show(alert: "Error", message: "Failed to reach server. This check-in will be saved in the local cache.", buttonTitle: "Ok", onSuccess: {
                            _ = self.navigationController?.popViewController(animated: true)
                        })
                    }
                    
                default: return
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
