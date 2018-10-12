//
//  Event.swift
//  premier-checkin-ios
//
//  Created by Elie El Khoury on 10/12/18.
//  Copyright © 2018 Elie El Khoury. All rights reserved.
//

import Foundation

struct Event : Decodable {
    var expiry : Int
    var url_logo : URL
    var url_event : URL
    var event_title : String
    var delete_code : String
    var contacts : [Participant]
    var hash : String
}
