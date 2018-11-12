//
//  Event.swift
//  premier-checkin-ios
//
//  Created by Elie El Khoury on 11/5/18.
//  Copyright © 2018 Elie El Khoury. All rights reserved.
//

import UIKit
import RealmSwift

class Event: Object, Decodable {
    
    @objc dynamic var url_logo  = ""
    @objc dynamic var url_event = ""
    @objc dynamic var event_title = ""
    @objc dynamic var delete_code = ""
    var t_tickets = List<TTicket>()
    var s_tickets = List<STicket>()
    var i_tickets = List<ITicket>()
    var e_tickets = List<ETicket>()
    
    override class func primaryKey() -> String? {
        return "url_event"
    }
    
    private enum CodingKeys: String, CodingKey {
        case url_logo
        case url_event
        case event_title
        case delete_code
        case t_tickets = "t_tickets"
        case s_tickets = "s_tickets"
        case i_tickets = "i_tickets"
        case e_tickets = "e_tickets"
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.url_logo  = try container.decode(String.self, forKey: .url_logo)
        self.url_event = try container.decode(String.self, forKey: .url_event)
        self.event_title = try container.decode(String.self, forKey: .event_title)
        self.delete_code = try container.decode(String.self, forKey: .delete_code)
        
        // Map JSON Array response into Realm List
        let tTickets = try container.decodeIfPresent([TTicket].self, forKey: .t_tickets) ?? [TTicket()]
        t_tickets.append(objectsIn: tTickets)

        let sTickets = try container.decodeIfPresent([STicket].self, forKey: .s_tickets) ?? [STicket()]
        s_tickets.append(objectsIn: sTickets)
        
        let iTickets = try container.decodeIfPresent([ITicket].self, forKey: .i_tickets) ?? [ITicket()]
        i_tickets.append(objectsIn: iTickets)
        
        let eTickets = try container.decodeIfPresent([ETicket].self, forKey: .e_tickets) ?? [ETicket()]
        e_tickets.append(objectsIn: eTickets)
    }
}
