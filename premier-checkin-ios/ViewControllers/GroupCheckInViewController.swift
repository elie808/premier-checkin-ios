//
//  ParticipantCheckInViewController.swift
//  premier-checkin-ios
//
//  Created by Elie El Khoury on 10/7/18.
//  Copyright © 2018 Elie El Khoury. All rights reserved.
//

import UIKit

class GroupCheckInViewController: UIViewController {

    // MARK: - Properties
    
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
    }
    
    // MARK: - Helpers
    
    // MARK: - Actions
        
    @IBAction func didTapAccept(_ sender: UIButton) {
//        show(alert: "Error", message: "Already Checked In", buttonTitle: "OK") {}
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
            return 30
        } else if collectionView == childCollectionView {
            return 1
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == adultCollectionView {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "adultCell", for: indexPath) as! GroupCollectionViewCell
            return cell
            
        } else if collectionView == childCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "childCell", for: indexPath) as! GroupCollectionViewCell
        
            return cell
            
        } else {
            
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == adultCollectionView {
            
        } else if collectionView == childCollectionView {
   
        }
    }
    
}
