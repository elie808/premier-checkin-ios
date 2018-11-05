//
//  ETicket.swift
//  premier-checkin-ios
//
//  Created by Elie El Khoury on 11/5/18.
//  Copyright © 2018 Elie El Khoury. All rights reserved.
//

import UIKit
import RealmSwift

class ETicket: Object, Decodable {
    
    @objc dynamic var reg_id = ""
    @objc dynamic var first_name = ""
    @objc dynamic var last_name = ""
    
    @objc dynamic var adult : GroupTicket?
    @objc dynamic var child : GroupTicket?
    
    override class func primaryKey() -> String? {
        return "reg_id"
    }
    
    private enum CodingKeys: String, CodingKey {
        case reg_id
        case first_name
        case last_name
        case adult
        case child
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.reg_id  = try container.decode(String.self, forKey: .reg_id)
        self.first_name = try container.decode(String.self, forKey: .first_name)
        self.last_name = try container.decode(String.self, forKey: .last_name)

        self.adult = try container.decode(GroupTicket.self, forKey: .adult)
        self.child = try container.decode(GroupTicket.self, forKey: .child)

//        let groupTickets = try container.decodeIfPresent([GroupTicket].self, forKey: .adult) ?? [GroupTicket()]
//        adult.append(objectsIn: groupTickets)
    }
}

class GroupTicket : Object, Decodable {
    
    @objc dynamic var sync_id = ""
    @objc dynamic var checkins_pending = 0
//    var checkins_dates = List<String>()

    override class func primaryKey() -> String? {
        return "sync_id"
    }
}
