//
//  PayerModel.swift
//  KitabMubin
//
//  Created by Hany Alkahlout on 23/01/2023.
//

import Foundation

struct CountriesModel: Decodable {
    var id : Int?
    var name : String?
    var name_ar : String?
    var citties : [Citties]?
}

struct Citties : Decodable {
    var id : Int?
    var name : String?
    var name_ar : String?
    var country_id : Int?
}
