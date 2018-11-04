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
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Views Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Helpers
    
    func configureView(with objb:String) {
        
//        numberLabel.text = ""
//        nameLabel.text = ""
//        genderImageView.image = UIImage(named: "")
//        ageLabel.text = ""
//        sizeImageView.image = UIImage(named: "")
    }
    
    // MARK: - Actions
    
    @IBAction func didTapSettings(_ sender: UIBarButtonItem) {
        present(settingsAlertController(), animated: true, completion: nil)
    }
    
    @IBAction func didTapDismiss(_ sender: UIButton) {
    }
    
    @IBAction func didTapAccept(_ sender: UIButton) {
        show(alert: "Error", message: "Already Checked In", buttonTitle: "OK") {}
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
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    
}
