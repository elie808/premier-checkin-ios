//
//  ITicket.swift
//  premier-checkin-ios
//
//  Created by Elie El Khoury on 11/5/18.
//  Copyright © 2018 Elie El Khoury. All rights reserved.
//

import UIKit
import RealmSwift

class ITicket: Object, Decodable {
    
    @objc dynamic var reg_id  = ""
    @objc dynamic var sync_id = ""
    @objc dynamic var bib = ""
    @objc dynamic var team_name : String?
    @objc dynamic var first_name = ""
    @objc dynamic var last_name  = ""
    @objc dynamic var gender = ""
    @objc dynamic var age = ""
    @objc dynamic var tshirt_size : String?
    @objc dynamic var checkin_date : String?
    
    override class func primaryKey() -> String? {
        return "reg_id"
    }
}
