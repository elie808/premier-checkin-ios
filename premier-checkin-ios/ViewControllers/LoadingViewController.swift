//
//  LoadingViewController.swift
//  premier-checkin-ios
//
//  Created by Elie El Khoury on 10/5/18.
//  Copyright © 2018 Elie El Khoury. All rights reserved.
//

import UIKit
import RealmSwift

class LoadingViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var progressView: UIProgressView!
    
    // MARK: - Views Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //TODO: Check if the app is online before segueing
        
//        show(alert: "App is offline", message: "You need to be connected when you first load the app. Connect to WiFi or turn on mobile data.",
//             buttonTitle: "Try again", onSuccess: {
//                print("Trying again")
//        })
        
        let realm = try! Realm()
        
        if realm.isEmpty == true {
            performSegue(withIdentifier: Segue.Loading.toEventNVC, sender: nil)
        } else {
            performSegue(withIdentifier: Segue.Loading.toCheckinNVC, sender: nil)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func updateProgress(_ sender: UIButton) {
        progressView.setProgress(0.7, animated: true)
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
