//
//  ParticipantCheckInViewController.swift
//  premier-checkin-ios
//
//  Created by Elie El Khoury on 10/7/18.
//  Copyright © 2018 Elie El Khoury. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire

class GroupCheckInViewController: UIViewController {

    // MARK: - Properties
    
    struct adultModel {
        var selected : Bool = false
    }
    
    struct childModel {
        var selected : Bool = false
    }
    
    var passedETicket : ETicket = ETicket()
    var adultsDataSource : [adultModel] = []
    var childrenDataSource : [childModel] = []
    
    // MARK: - Outlets
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var adultCollectionView: UICollectionView!
    @IBOutlet weak var childCollectionView: UICollectionView!
    @IBOutlet weak var adultCountLabel : UILabel!
    @IBOutlet weak var childCountLabel : UILabel!
    
    // MARK: - Views Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configViewController()
    }
    
    // MARK: - Actions
    
    @IBAction func didTapAccept(_ sender: UIButton) {

        let Url = "https://www.premieronline.com/webservice/checkin/sync.php?code=\(Defaults.eventCode)&secret=\(Defaults.appSecret)"
        
        let selectedAdults = adultsDataSource.filter{ ($0.selected == true) }.count
        let selectedChildren = childrenDataSource.filter{ ($0.selected == true) }.count
        
        let currentTime = Int64(NSDate().timeIntervalSince1970)
        
        var postData : [SyncObject] = []
        
        if selectedAdults > 0 {
            postData.append(SyncObject(sync_id: (passedETicket.adult?.sync_id)!, quantity: String(selectedAdults), checkin_date: String(currentTime)))
        }
        
        if selectedChildren > 0 {
            postData.append(SyncObject(sync_id: (passedETicket.child?.sync_id)!, quantity: String(selectedChildren), checkin_date: String(currentTime)))
        }
        
        // POST when there's data
        if postData.isEmpty == false && postData.count > 0 {
        
            var dictArray : [Any] = []
            for syncObj in postData {
                dictArray.append(syncObj.convertToDict())
            }
            
            let params = ["data" : dictArray]
            
            addToCache(postData)
            
            post(url: Url, parameterDictionary: params, completion: { (response:Checkin) in
                
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
                    self.removeFromCache(removeFromCacheData)
                    self.updateDBWithValues(updateDBData)
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

extension GroupCheckInViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == adultCollectionView {
            return adultsDataSource.count
        } else if collectionView == childCollectionView {
            return childrenDataSource.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == adultCollectionView {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "adultCell", for: indexPath) as! GroupCollectionViewCell
            
            if adultsDataSource[indexPath.row].selected == true {
                cell.logoImageView.image = UIImage(named: "adult_selected")
            } else {
                cell.logoImageView.image = UIImage(named: "adult_unselected")
            }
            
            return cell
            
        } else if collectionView == childCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "childCell", for: indexPath) as! GroupCollectionViewCell
        
            if childrenDataSource[indexPath.row].selected == true {
                cell.logoImageView.image = UIImage(named: "child_selected")
            } else {
                cell.logoImageView.image = UIImage(named: "child_unselected")
            }
            
            return cell
            
        } else {
            
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == adultCollectionView {
            if adultsDataSource[indexPath.row].selected == true {
                adultsDataSource[indexPath.row].selected = false
            } else {
                adultsDataSource[indexPath.row].selected = true
            }
        } else if collectionView == childCollectionView {
            
            if childrenDataSource[indexPath.row].selected == true {
               childrenDataSource[indexPath.row].selected = false
            } else {
                childrenDataSource[indexPath.row].selected = true
            }
        }
        
        collectionView.reloadData()
    }
    
}

// MARK: - Helpers

extension GroupCheckInViewController {
    
    func configViewController() {
        
        for _ in 0 ..< (passedETicket.adult?.checkins_pending)! {
            adultsDataSource.append(adultModel())
        }
        
        for _ in 0 ..< (passedETicket.child?.checkins_pending)! {
            childrenDataSource.append(childModel())
        }
        
        adultCountLabel.text = "ADULT (\(adultsDataSource.count))"
        childCountLabel.text = "CHILD (\(childrenDataSource.count))"
    }
    
}
