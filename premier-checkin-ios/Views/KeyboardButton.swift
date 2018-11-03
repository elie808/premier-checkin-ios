//
//  KeyboardButton.swift
//  premier-checkin-ios
//
//  Created by Elie El Khoury on 10/6/18.
//  Copyright © 2018 Elie El Khoury. All rights reserved.
//

import UIKit
@IBDesignable

class KeyboardButton: UIButton {

    @IBInspectable open var gradientColor1: UIColor = #colorLiteral(red: 0.1960784314, green: 0.2470588235, blue: 0.3843137255, alpha: 1)
    @IBInspectable open var gradientColor2: UIColor = #colorLiteral(red: 0.3529411765, green: 0.4039215686, blue: 0.5411764706, alpha: 1)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        applyKeyboardButtonGradient(color1: gradientColor1, color2: gradientColor2)
        addRoundedCorners()
//        self.setTitleColor(UIColor.butlrBlack, for: .normal)
//        self.setTitleColor(UIColor.butlrBlack, for: .highlighted)
//        self.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
    }


}
