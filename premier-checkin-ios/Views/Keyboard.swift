//
//  Keyboard.swift
//  premier-checkin-ios
//
//  Created by Elie El Khoury on 10/5/18.
//  Copyright © 2018 Elie El Khoury. All rights reserved.
//

import UIKit

protocol KeyboardDelegate: class {
    func keyWasTapped(character: String)
    func backspaceTapped()
    func searchTapped()
}

class Keyboard: UIView {

    weak var delegate: KeyboardDelegate?
    
    // MARK:- Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
    }
    
    func initializeSubviews() {
        let xibFileName = "Keyboard" // xib extention not included
        let view = Bundle.main.loadNibNamed(xibFileName, owner: self, options: nil)?[0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds
    }
    
    // MARK:- Actions
    
    @IBAction func keyTapped(sender: UIButton) {
        if delegate != nil {
            self.delegate?.keyWasTapped(character: sender.titleLabel!.text!) // could alternatively send a tag value
        }
    }
    
    @IBAction func didTapBackspace(sender: UIButton) {
        if delegate != nil {
            self.delegate?.backspaceTapped()
        }
    }
    
    @IBAction func didTapSearch(sender: UIButton) {
        if delegate != nil {
            self.delegate?.searchTapped()
        }
    }
}
