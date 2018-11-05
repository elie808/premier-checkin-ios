//
//  TTicket.swift
//  premier-checkin-ios
//
//  Created by Elie El Khoury on 11/5/18.
//  Copyright © 2018 Elie El Khoury. All rights reserved.
//

import UIKit

struct TTicket: Decodable {
    var reg_id : String
    var sync_id : String
    var company : String
    var ticket_type : String
    var checkin_date : String?
}
