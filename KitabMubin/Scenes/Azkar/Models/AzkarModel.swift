//
//  AzkarModel.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 30/10/2022.
//

import Foundation

struct AzkarModel: Decodable {
    var azkar: [Azkar]?
}

struct Azkar: Decodable {
    var id: Int?
    var title: String?
    var desc: [AzkarDescription]?
}

struct AzkarDescription: Decodable {
    var id: Int?
    var title: String?
    var text: String?
    var times: String?
}
