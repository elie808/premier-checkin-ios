//
//  DBManager.swift
//  premier-checkin-ios
//
//  Created by Elie El Khoury on 11/12/18.
//  Copyright © 2018 Elie El Khoury. All rights reserved.
//

import UIKit
import RealmSwift
import SVProgressHUD

class DBManager {
    
    // MARK: - Helpers
    
    /// get on-disk location of the default Realm
    class func dbLocation() {
        let realm = try! Realm()
        print("Realm is located at:", realm.configuration.fileURL!)
    }
    
    // MARK: - Search
    
    /// search DB for ticket objects using reg_ID
    class func searchDB(forID regID : String) -> Any? {
        
        let realm = try! Realm()
        
        let tTicketPrefix = "T" + regID
        let tPredicate = NSPredicate(format: "reg_id = %@", tTicketPrefix) // only used for t_tickets
        let predicate = NSPredicate(format: "reg_id = %@", regID) // used for the other tickets
        
        let sTickets = realm.objects(STicket.self).filter(predicate)
        
        if sTickets.isEmpty == false {
            
            return sTickets.first
            
        } else {
            
            let tTickets = realm.objects(TTicket.self).filter(tPredicate)
            
            if tTickets.isEmpty == true {
                
                let eTickets = realm.objects(ETicket.self).filter(predicate)
                
                if eTickets.isEmpty == true {
                    
                    let iTickets = realm.objects(ITicket.self).filter(predicate)
                    
                    if iTickets.isEmpty == true {
                        return nil
                    } else {
                        return iTickets.first
                    }
                    
                } else {
                    return eTickets.first
                }
                
            } else {
                return tTickets.first
            }
        }
    }
    
    /// search DB for ticket objects using sync_ID
    class func searchDB(forSyncID syncID : String) -> Any? {
        
        let realm = try! Realm()
  
        let tTicketPrefix = "t" + syncID
        let tPredicate = NSPredicate(format: "sync_id = %@", tTicketPrefix) // only used for t_tickets
        let predicate = NSPredicate(format: "sync_id = %@", syncID) // used for the other tickets
        
        let sTickets = realm.objects(STicket.self).filter(predicate)
        
        if sTickets.isEmpty == false {
            
            return sTickets.first
            
        } else {
            
            let tTickets = realm.objects(TTicket.self).filter(tPredicate)
            
            if tTickets.isEmpty == true {
                
                // search GroupTickets because ETickets have no sync_id
                let groupTickets = realm.objects(GroupTicket.self).filter(predicate)
                
                if groupTickets.isEmpty == true {
                    
                    let iTickets = realm.objects(ITicket.self).filter(predicate)
                    
                    if iTickets.isEmpty == true {
                        return nil
                    } else {
                        return iTickets.first
                    }
                    
                } else {
                    return groupTickets.first
                }
                
            } else {
                return tTickets.first
            }
        }
    }
    
    // MARK: - Add/Update
    
    /// update an array of SyncObjects with new values
    class func updateDBWithValues(_ updatedRecords: [SyncObject]) {
        
        let realm = try! Realm()
        
        for postObj in updatedRecords {
            
            if let existingObj = DBManager.searchDB(forSyncID: postObj.sync_id) {
                
                // update object if it exists in DB
                switch existingObj {
                    
                case is GroupTicket:
                    try! realm.write {
                        (existingObj as! GroupTicket).checkins_pending = postObj.checkins_pending
                    }
                    
                case is STicket:
                    try! realm.write {
                        (existingObj as! STicket).checkins_pending = postObj.checkins_pending
                    }
                    
                case is TTicket:
                    try! realm.write {
                        (existingObj as! TTicket).checkins_pending = postObj.checkins_pending
                    }
                    
                case is ITicket:
                    try! realm.write {
                        (existingObj as! ITicket).checkins_pending = postObj.checkins_pending
                    }
                    
                default:
                    return
                }
            }
        }
    }
    
    /// cache SyncObjects for later use
    class func addToCache(_ postData: [SyncObject]) {
        
        let realm = try! Realm()
        
        for postObj in postData {            
            try! realm.write {
                realm.add(postObj)
            }
        }
    }
   
    // MARK: - Delete
    
    /// remove SyncObjects from cache
    class func removeFromCache(_ postData: [SyncObject]) {
        
        let realm = try! Realm()
        
        for postObj in postData {
            
            let predicate = NSPredicate(format: "sync_id = %@", postObj.sync_id) // used for the other tickets
            let postObjs = realm.objects(SyncObject.self).filter(predicate)
            
            try! realm.write {
                realm.delete(postObjs)
            }
        }
    }
    
    /// check if cache is empty
    class func cacheEmpty() -> Bool {
        
        let realm = try! Realm()
        let cacheObj = realm.objects(SyncObject.self)
        
        if cacheObj.isEmpty == true {
            return true
        } else {
            return false
        }
    }
    
    class func emptyCache() {
        
        let realm = try! Realm()
        let cacheObj = realm.objects(SyncObject.self)
        
        try! realm.write {
            realm.delete(cacheObj)
        }
    }
    
    class func emptyDB() {
        
        let realmURL = Realm.Configuration.defaultConfiguration.fileURL!
        let realmURLs = [realmURL, realmURL.appendingPathExtension("lock"), realmURL.appendingPathExtension("note"), realmURL.appendingPathExtension("management") ]
        
        for URL in realmURLs {
            do {
                try FileManager.default.removeItem(at: URL)
            } catch {
                // handle error
            }
        }
    }
    
}
