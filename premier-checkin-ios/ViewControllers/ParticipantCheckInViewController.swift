//
//  ParticipantCheckInViewController.swift
//  premier-checkin-ios
//
//  Created by Elie El Khoury on 10/7/18.
//  Copyright © 2018 Elie El Khoury. All rights reserved.
//

import UIKit

class ParticipantCheckInViewController: UIViewController {

    // MARK: - Properties
    
    // MARK: - Outlets
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderImageView: UIImageView!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var sizeImageView: UIImageView!
    
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
