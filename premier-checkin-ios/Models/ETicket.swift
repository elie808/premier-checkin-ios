//
//  ETicket.swift
//  premier-checkin-ios
//
//  Created by Elie El Khoury on 11/5/18.
//  Copyright © 2018 Elie El Khoury. All rights reserved.
//

import UIKit

struct ETicket: Decodable {
    var reg_id : String
    var first_name : String
    var last_name : String
    var adult : GroupTicket
    var child : GroupTicket
}

struct GroupTicket : Decodable {
    var sync_id : String
    var checkins_dates : [String]
    var checkins_pending : Int
}
