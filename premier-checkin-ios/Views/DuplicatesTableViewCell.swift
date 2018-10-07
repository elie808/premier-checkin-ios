//
//  DuplicatesTableViewCell.swift
//  premier-checkin-ios
//
//  Created by Elie El Khoury on 10/7/18.
//  Copyright © 2018 Elie El Khoury. All rights reserved.
//

import UIKit

class DuplicatesTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: - Views Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(with ojb:String) {
        
    }
}
