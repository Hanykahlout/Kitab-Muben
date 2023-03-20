//
//  SavedPage.swift
//  KitabMubin
//
//  Created by Hany Alkahlout on 09/01/2023.
//

import Foundation
import RealmSwift

class SavedPage: Object {
    
    @Persisted var suraName: String?
    @Persisted var jozzNumber: Int?
    @Persisted var pageNumber: Int?
    @Persisted var suraContent: String?
    @Persisted var hideBasmala: Bool?
    
    override class func primaryKey() -> String? {
        return "pageNumber"
    }
    
}
