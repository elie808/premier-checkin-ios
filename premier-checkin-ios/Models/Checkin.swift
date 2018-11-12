//
//  Checkin.swift
//  premier-checkin-ios
//
//  Created by Elie El Khoury on 11/7/18.
//  Copyright © 2018 Elie El Khoury. All rights reserved.
//

import UIKit
import RealmSwift

class Checkin : Codable {
    
//    var errors = List<SyncObject>()
//    var updates = List<SyncObject>()

    var errors : [SyncObject] = []
    var updates : [SyncObject] = []

    private enum CodingKeys: String, CodingKey {
        case errors
        case updates
    }

    public required convenience init(from decoder: Decoder) throws {
        self.init()

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.errors = try container.decodeIfPresent([SyncObject].self, forKey: .errors)!
        self.updates = try container.decodeIfPresent([SyncObject].self, forKey: .updates)!
    }
}

class SyncObject: Object, Codable {

    @objc dynamic var sync_id = ""
    @objc dynamic var quantity = ""
    @objc dynamic var checkin_date : String?
    @objc dynamic var checkins_pending : Int = 0
    @objc dynamic var response_code : String = ""
    @objc dynamic var response_message : String = ""
    
    convenience init(sync_id: String, quantity: String, checkin_date: String) {
        self.init()

        self.sync_id  = sync_id
        self.quantity = quantity
        self.checkin_date = checkin_date
    }

    override class func primaryKey() -> String? {
        return "sync_id"
    }

    private enum CodingKeys: String, CodingKey {
        case sync_id
        case quantity
        case checkin_date
        case checkins_pending
        case response_code
        case response_message
    }
    
//    func encode(to encoder: Encoder) throws {
//
//        var container = encoder.container(keyedBy: CodingKeys.self)
//
//        try container.encode(self.sync_id, forKey: .sync_id)
//        try container.encode(self.quantity, forKey: .quantity)
//        try container.encode(self.checkin_date, forKey: .checkin_date)
//    }

    func convertToDict() -> [String : Any] {
        
        let dicc = [
                CodingKeys.sync_id.rawValue : self.sync_id,
                CodingKeys.quantity.rawValue : self.quantity,
                CodingKeys.checkin_date.rawValue : self.checkin_date!,
                CodingKeys.checkins_pending.rawValue : self.checkins_pending,
                CodingKeys.response_code.rawValue : self.response_code,
                CodingKeys.response_message.rawValue : self.response_message
            ] as [String : Any]
        
        return dicc as [String : Any]
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.sync_id  = try container.decode(String.self, forKey: .sync_id)
        self.quantity = try container.decode(String.self, forKey: .quantity)
//        self.checkin_date = try container.decode(String.self, forKey: .checkin_date)
        self.checkins_pending  = try container.decode(Int.self, forKey: .checkins_pending)
        self.response_code = try container.decode(String.self, forKey: .response_code)
        self.response_message = try container.decode(String.self, forKey: .response_message)
    }
}
