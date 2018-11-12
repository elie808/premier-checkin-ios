//
//  TTicket.swift
//  premier-checkin-ios
//
//  Created by Elie El Khoury on 11/5/18.
//  Copyright © 2018 Elie El Khoury. All rights reserved.
//

import UIKit
import RealmSwift

class TTicket: Object, Decodable {
    
    @objc dynamic var reg_id  = ""
    @objc dynamic var sync_id = ""
    @objc dynamic var title = ""
    @objc dynamic var checkins_pending : Int = 0
//    @objc dynamic var checkin_date : String?
    
    override class func primaryKey() -> String? {
        return "reg_id"
    }
}
