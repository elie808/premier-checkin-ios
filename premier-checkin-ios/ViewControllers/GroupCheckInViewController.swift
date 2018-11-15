//
//  ParticipantCheckInViewController.swift
//  premier-checkin-ios
//
//  Created by Elie El Khoury on 10/7/18.
//  Copyright © 2018 Elie El Khoury. All rights reserved.
//

import UIKit
import RealmSwift

class GroupCheckInViewController: UIViewController {

    // MARK: - Properties
    
    struct adultModel {
        var selected : Bool = false
    }
    
    struct childModel {
        var selected : Bool = false
    }
    
    var passedETicket : ETicket?
    var passedSTicket : STicket?
    
    var adultsDataSource : [adultModel] = []
    var childrenDataSource : [childModel] = []
    
    // MARK: - Outlets
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var adultCollectionView: UICollectionView!
    @IBOutlet weak var childCollectionView: UICollectionView!
    @IBOutlet weak var adultCountLabel : UILabel!
    @IBOutlet weak var selectedAdultsCountLabel: UILabel!
    @IBOutlet weak var childCountLabel : UILabel!
    @IBOutlet weak var selecterdChildrenCountLabel: UILabel!
    
    // MARK: - Views Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViewController()
    }
    
    // MARK: - Actions
    
    @IBAction func didTapAccept(_ sender: UIButton) {

        var postData : [SyncObject] = []
        
        let selectedAdults = adultsDataSource.filter{ ($0.selected == true) }.count
        let selectedChildren = childrenDataSource.filter{ ($0.selected == true) }.count
        
        let currentTime = Int64(NSDate().timeIntervalSince1970)
        
        if let eTicket = passedETicket {
            if selectedAdults > 0 {
                postData.append(SyncObject(sync_id: (eTicket.adult?.sync_id)!, quantity: String(selectedAdults), checkin_date: String(currentTime)))
            }
            
            if selectedChildren > 0 {
                postData.append(SyncObject(sync_id: (eTicket.child?.sync_id)!, quantity: String(selectedChildren), checkin_date: String(currentTime)))
            }
        }
        
        if let sTicket = passedSTicket {
            if selectedAdults > 0 {
                postData.append(SyncObject(sync_id: sTicket.sync_id, quantity: String(selectedAdults), checkin_date: String(currentTime)))
            }
            
            if selectedChildren > 0 {
                postData.append(SyncObject(sync_id: sTicket.sync_id, quantity: String(selectedChildren), checkin_date: String(currentTime)))
            }
        }
        
        postCheckinData(postData)
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
        setHeaderLabelValues()
    }
    
}

// MARK: - Helpers

extension GroupCheckInViewController {
    
    func configViewController() {
        
        if let eTicket = passedETicket {
            for _ in 0 ..< (eTicket.adult?.checkins_pending)! {
                adultsDataSource.append(adultModel())
            }
            
            for _ in 0 ..< (eTicket.child?.checkins_pending)! {
                childrenDataSource.append(childModel())
            }
            
            setHeaderLabelValues()
        }
        
        if let sTicket = passedSTicket {
            
            for _ in 0 ..< (sTicket.checkins_pending) {
                childrenDataSource.append(childModel())
            }
            
            setHeaderLabelValues()
        }
    }

    func setHeaderLabelValues() {
        selectedAdultsCountLabel.text = "\(adultsDataSource.filter{ ($0.selected == true) }.count) selected"
        selecterdChildrenCountLabel.text = "\(childrenDataSource.filter{ ($0.selected == true) }.count) selected"
        
        adultCountLabel.text = "ADULT (\(adultsDataSource.count))"
        childCountLabel.text = "CHILD (\(childrenDataSource.count))"
    }
    
}
