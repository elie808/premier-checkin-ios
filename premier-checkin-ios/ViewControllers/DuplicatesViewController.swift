//
//  DuplicatesViewController.swift
//  premier-checkin-ios
//
//  Created by Elie El Khoury on 10/7/18.
//  Copyright © 2018 Elie El Khoury. All rights reserved.
//

import UIKit

class DuplicatesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties
    
    let cellID = "CellID"
    var dataSource : [String] = []
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView : UITableView!
    
    // MARK: - Views Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = ["asd", "dqd"]
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! DuplicatesTableViewCell
        cell.configureCell(with: "dummuy")
        return cell
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "participantCheckin", sender: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func didTapSettings(_ sender: UIBarButtonItem) {
        present(settingsAlertController(), animated: true, completion: nil)
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
