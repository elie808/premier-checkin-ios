//
//  UserDefaults.swift
//  premier-checkin-ios
//
//  Created by Elie El Khoury on 11/13/18.
//  Copyright © 2018 Elie El Khoury. All rights reserved.
//

import UIKit

struct Defaults {
    
    // Mark: - Constants
    
    private static let kEventCode : String = "3796204"
    private static let kAppSecret : String = "ZnX59SzKHgzuYuVjoE5s"

    // Mark: - Keys
    
    private static let kEventCodeKey = "premiere_sports_event_code"
    private static let kAppSecretKey = "premiere_sports_secret"
    private static let kCacheStatusKey  = "premiere_cache_status"
    private static let kLastSyncKey     = "premiere_sports_last_sync"
    private static let kDBLastRefreshKey = "premiere_sports_DB_last_refresh"
    
    // Mark: - Save Methods
    
    static func saveLastSyncDate() {
        UserDefaults.standard.set(Date(), forKey: kLastSyncKey)
    }
    
    static func setCacheEmpty(flag : Bool) {
        UserDefaults.standard.set(flag, forKey: kCacheStatusKey)
    }
    
    static func saveLastDbRefreshDate() {
        UserDefaults.standard.set(Date(), forKey: kDBLastRefreshKey)
    }
    
    static func saveEventCode(code:String) {
        UserDefaults.standard.set(code, forKey: kEventCodeKey)
    }
    
    static func persistDefaults() {
        let defaults = UserDefaults.standard
        
        defaults.set(kEventCode, forKey: kEventCodeKey)
        defaults.set(kAppSecret, forKey: kAppSecretKey)
    }
    
    // Mark: - GET Methods
    
    static var cacheStatus = { _ -> String in
        
        let isCacheEmpty = (UserDefaults.standard.value(forKey: kCacheStatusKey)) as? Bool
        
        if isCacheEmpty == true {
            return "Cache is empty"
        } else {
            return "Cache has elements"
        }
    }(())
    
    static var eventCode = { _ -> String in
        return ((UserDefaults.standard.value(forKey: kEventCodeKey) as? String) ?? kEventCode)
    }(())

    static var appSecret = { _ -> String in
        return ((UserDefaults.standard.value(forKey: kAppSecretKey) as? String) ?? kAppSecret)
    }(())

    static var lastDbRefreshDate = { _ -> String in
        
        let savedDate = (UserDefaults.standard.value(forKey: kDBLastRefreshKey)) as? Date
        
        if savedDate == nil {
            return "_"
        } else {
            return savedDate!.getElapsedInterval()
        }
    }(())
    
    static var lastSyncDate = { _ -> String in
        
        let savedDate = (UserDefaults.standard.value(forKey: kLastSyncKey)) as? Date
        
        if savedDate == nil {
            return "_"
        } else {
            return savedDate!.getElapsedInterval()
        }
    }(())
    
    // MARK: - Delete
    
    static func clearLastSyncDate() {
        UserDefaults.standard.removeObject(forKey: kLastSyncKey)
    }

    static func clearEventCode() {
        UserDefaults.standard.removeObject(forKey: kEventCodeKey)
    }
    
    static func clearUserDefaults(){
        UserDefaults.standard.removeObject(forKey: kEventCodeKey)
        UserDefaults.standard.removeObject(forKey: kAppSecretKey)
        UserDefaults.standard.removeObject(forKey: kLastSyncKey)
        UserDefaults.standard.removeObject(forKey: kCacheStatusKey)
        UserDefaults.standard.removeObject(forKey: kDBLastRefreshKey)
    }

}
