//
//  Event.swift
//  premier-checkin-ios
//
//  Created by Elie El Khoury on 11/5/18.
//  Copyright © 2018 Elie El Khoury. All rights reserved.
//

import UIKit

struct Event : Decodable {
    var url_logo : String
    var url_event : String
    var event_title : String
    var delete_code : String
    var t_tickets : [TTicket]
    var i_tickets : [ITicket]
    var e_tickets : [ETicket]
}
