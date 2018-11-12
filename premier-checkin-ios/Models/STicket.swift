//
//  STicket.swift
//  premier-checkin-ios
//
//  Created by Elie El Khoury on 11/12/18.
//  Copyright © 2018 Elie El Khoury. All rights reserved.
//

import UIKit
import RealmSwift

class STicket: Object, Decodable {
    
    @objc dynamic var reg_id  = ""
    @objc dynamic var sync_id = ""
    @objc dynamic var title = ""
    @objc dynamic var checkins_pending = 0
//    @objc dynamic var checkins_dates : [String] = []
    
    override class func primaryKey() -> String? {
        return "reg_id"
    }
}
