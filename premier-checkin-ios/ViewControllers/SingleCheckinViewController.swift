//
//  SingleCheckinViewController.swift
//  premier-checkin-ios
//
//  Created by Elie El Khoury on 11/4/18.
//  Copyright © 2018 Elie El Khoury. All rights reserved.
//

import UIKit

class SingleCheckinViewController: UIViewController {

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
        
    }
    
    // MARK: - Actions
    
    @IBAction func didTapAccept(_ sender: UIButton) {
        // show(alert: "Error", message: "Already Checked In", buttonTitle: "OK") {}
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
