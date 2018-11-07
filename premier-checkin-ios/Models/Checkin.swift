//
//  Checkin.swift
//  premier-checkin-ios
//
//  Created by Elie El Khoury on 11/7/18.
//  Copyright © 2018 Elie El Khoury. All rights reserved.
//

import UIKit
import RealmSwift

class Checkin: Decodable {
    var errors : [SyncObject]?
    var updates : [SyncObject]?
}

class SyncObject: Object, Decodable {
    
    @objc dynamic var sync_id = ""
    @objc dynamic var quantity = ""
    @objc dynamic var checkin_date : String?
    
//    @objc dynamic var checkins_pending : Int?
    @objc dynamic var response_code : String?
    @objc dynamic var response_message : String?
    
    override class func primaryKey() -> String? {
        return "sync_id"
    }
    
    private enum CodingKeys: String, CodingKey {
        case sync_id
        case quantity
        case checkin_date
        case response_code
        case response_message
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.sync_id  = try container.decode(String.self, forKey: .sync_id)
        self.quantity = try container.decode(String.self, forKey: .quantity)
        self.checkin_date = try container.decode(String.self, forKey: .checkin_date)
        
        self.response_code = try container.decode(String.self, forKey: .response_code)
        self.response_message = try container.decode(String.self, forKey: .response_message)
    }
}
