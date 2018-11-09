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
    
    // MARK: - Helpers
    
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
    
    fileprivate func addToCache(_ postData: [SyncObject]) {
        
        let realm = try! Realm()

        for postObj in postData {

            let predicate = NSPredicate(format: "sync_id = %@", postObj.sync_id) // used for the other tickets
            let postObjs = realm.objects(SyncObject.self).filter(predicate)

            if let obj = postObjs.first {
                try! realm.write {
                    obj.checkin_date = postObj.checkin_date
                    obj.quantity = postObj.quantity
                }
            }
        }
    }
    
    fileprivate func removeFromCache(_ postData: [SyncObject]) {
        
        let realm = try! Realm()

        for postObj in postData {

            let predicate = NSPredicate(format: "sync_id = %@", postObj.sync_id) // used for the other tickets
            let postObjs = realm.objects(SyncObject.self).filter(predicate)
            try! realm.write {
                realm.delete(postObjs)
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func didTapAccept(_ sender: UIButton) {

        //        show(alert: "Error", message: "Already Checked In", buttonTitle: "OK") {}
        
        let secret = "ZnX59SzKHgzuYuVjoE5s"
        let eventCode = "3796204"
        let Url = "https://www.premieronline.com/webservice/checkin/sync.php?code=\(eventCode)&secret=\(secret)"
        
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
        
        addToCache(postData)
        
        var dictArray : [Any] = []
        for syncObj in postData {
            dictArray.append(syncObj.convertToDict())
        }
        
        let params = ["data" : dictArray]
        
        //TODO: CREATE A OBJECT TO DICTIONARY METHOD !!!!!!!!!!
        
//        let params = ["data" : [ ["sync_id": "i695578", "quantity": "1", "checkin_date": ""], ["sync_id": "e2236744", "quantity": "1", "checkin_date": ""] ] ]
//        let dataZ = SyncObject(sync_id: "i695578", quantity: "1", checkin_date: "")

//        let enconder = JSONEncoder()
//        let encoded = try? enconder.encode(toSend)
        
        post(url: Url, parameterDictionary: params) { (checkinObj : Checkin) in

            print("\n \n JSON: \n", checkinObj)

//            TODO: Update DB (Event table) with success checkin_dates & checkins_pending
//            self.removeFromCache(postData)
        }
        
        
//        Alamofire.request(Url, method: .post, parameters: params, encoding: JSONEncoding.default).responseData { (xxx) in
//            print("SHI: ", xxx)
//        }

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
