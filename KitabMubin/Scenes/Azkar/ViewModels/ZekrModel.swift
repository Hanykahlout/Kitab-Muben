//
//  File.swift
//  KitabMubin
//
//  Created by Hany Alkahlout on 22/01/2023.
//

import Foundation
import RealmSwift

class ZekrModel: Object{
    @Persisted var id:Int?
    @Persisted var name: String = ""
    @Persisted var notification_id: String?
    @Persisted var date: Date?
    @Persisted var descriptions: List<ZekrDescriptionModel>
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
