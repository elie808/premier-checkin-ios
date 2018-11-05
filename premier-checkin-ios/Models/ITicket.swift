//
//  ITicket.swift
//  premier-checkin-ios
//
//  Created by Elie El Khoury on 11/5/18.
//  Copyright © 2018 Elie El Khoury. All rights reserved.
//

import UIKit

struct ITicket: Decodable {
    var reg_id : String
    var sync_id : String
    var bib : String
    var team_name : String?
    var first_name : String
    var last_name : String
    var gender : String
    var age : String
    var tshirt_size : String?
    var checkin_date : String?
}
