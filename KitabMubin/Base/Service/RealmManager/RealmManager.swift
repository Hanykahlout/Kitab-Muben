//
//  RealmManager.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 21/10/2022.
//

import Foundation
import RealmSwift

class RealmManager: RealmManagerInterface {
    
    // MARK: - Variables And Properties
    static let sharedInstance = RealmManager()
    
    // MARK: Saving
    func saveObjects<T: Object>(_ objects: [T]) {
        if let realm = try? Realm() {
            try? realm.write {
                realm.add(objects)
            }
        }
    }
    
    func saveObject<T: Object>(_ object: T) {
        if let realm = try? Realm() {
            try? realm.write {
                realm.add(object)
            }
        }
    }
    
    // MARK: Fetching
    func fetchObjects<T: Object>(_ type: T.Type) -> [T]? {
        guard let realm = try? Realm() else { return nil }
        return Array(realm.objects(type))
    }
    
    func fetchObjects<T: Object>(_ type: T.Type, predicate: NSPredicate) -> [T]? {
        guard let realm = try? Realm() else { return nil }
        return Array(realm.objects(type).filter(predicate))
    }
    
    // MARK: Remove
    func removeObjects<T: Object>(_ objects: [T]) {
        if let realm = try? Realm() {
            try? realm.write {
                realm.delete(objects)
            }
        }
    }
    
    func removeObject<T: Object>(_ object: T) {
        if let realm = try? Realm() {
            try? realm.write {
                realm.delete(object)
            }
        }
    }
    
    func removeAllObjectsOfType<T: Object>(_ type: T.Type) {
        if let realm = try? Realm() {
            try? realm.write {
                realm.delete(realm.objects(T.self))
            }
        }
    }
    
    func removeAll() {
        if let realm = try? Realm() {
            try? realm.write({
                realm.deleteAll()
            })
        }
    }
    
    func removeWhere<T: Object>(column:String,value:Any,for: T.Type){
        if let realm = try? Realm() {
            try! realm.write {
                realm.delete(realm.objects(T.self).filter("\(column) = \(value)"))
            }
        }
    }
    
}
