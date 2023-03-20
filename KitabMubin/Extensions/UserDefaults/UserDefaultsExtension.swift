//
//  UserDefaultsExtension.swift
//  KitabMubin
//
//  Created by MoamenHalanMac on 24/07/2022.
//

import Foundation

public extension UserDefaults {
    enum Key: String {
       case reviewWorthyActionCount
       case lastReviewRequestAppVersion
     }

     func integer(forKey key: Key) -> Int {
       return integer(forKey: key.rawValue)
     }

     func string(forKey key: Key) -> String? {
       return string(forKey: key.rawValue)
     }

     func set(_ integer: Int, forKey key: Key) {
       set(integer, forKey: key.rawValue)
     }

     func set(_ object: Any?, forKey key: Key) {
       set(object, forKey: key.rawValue)
     }
    
    /// EZSE: Generic getter and setter for UserDefaults.
    subscript(key: String) -> AnyObject? {
        get {
            return object(forKey: key) as AnyObject?
        }
        set {
            set(newValue, forKey: key)
        }
    }
    
    /// EZSE: Date from UserDefaults.
    func date(forKey key: String) -> Date? {
        return object(forKey: key) as? Date
    }
}
