//
//  CheckinActionButton.swift
//  premier-checkin-ios
//
//  Created by Elie El Khoury on 10/8/18.
//  Copyright © 2018 Elie El Khoury. All rights reserved.
//

import UIKit

class CheckinActionButton: UIButton {

    // MARK: - Inspectables
    
    @IBInspectable public var borderWidth: CGFloat = 2.0 {
        didSet {
            self.layer.borderWidth = self.borderWidth
        }
    }
    
    @IBInspectable public var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = self.borderColor.cgColor
        }
    }
    
    // MARK: - Views Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func draw(_ rect: CGRect) {
        addRoundedCorners()
        addBorder(width: borderWidth, color: borderColor)
    }

}
