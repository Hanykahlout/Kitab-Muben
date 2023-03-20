//
//  ZekrDescriptionModel.swift
//  KitabMubin
//
//  Created by Hany Alkahlout on 22/01/2023.
//

import Foundation
import RealmSwift

class ZekrDescriptionModel:Object{
    @Persisted var id:Int?
    @Persisted var title:String = ""
    @Persisted var text:String = ""
    @Persisted var times:String = ""
}
