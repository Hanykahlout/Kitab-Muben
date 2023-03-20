//
//  NotificationsCenterHelper.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 22/11/2022.
//

import Foundation

class NotificationsCenterHelper: NSObject {

    class func post(name:Notification.Name,object:Any? = nil,userInfo:[String:Any]? = nil){
        NotificationCenter.default.post(name: name, object: object, userInfo: userInfo)
    }
    
    class func startListening(to name:Notification.Name,at observer:Any,selector:Selector){
        NotificationCenter.default.addObserver(observer, selector: selector, name: name, object: nil)
    }
    
    class func stopListening(to name:Notification.Name,at observer:Any){
        NotificationCenter.default.removeObserver(observer, name: name, object: nil)
    }
}

