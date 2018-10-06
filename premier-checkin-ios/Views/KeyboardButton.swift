//
//  KeyboardButton.swift
//  premier-checkin-ios
//
//  Created by Elie El Khoury on 10/6/18.
//  Copyright © 2018 Elie El Khoury. All rights reserved.
//

import UIKit

class KeyboardButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        applyKeyboardButtonGradient()
        addRoundedCorners()
//        self.setTitleColor(UIColor.butlrBlack, for: .normal)
//        self.setTitleColor(UIColor.butlrBlack, for: .highlighted)
//        self.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
    }


}
