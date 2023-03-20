//
//  JuzsModel.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 23/10/2022.
//

import Foundation

struct JuzsResponse: Decodable {
    let juzs: [JuzsModel]?
}

struct JuzsModel: Decodable {
    let id: Int?
    let juz_number: Int?
    let juz_name: String?
    var page_number: Int?
    let verse_mapping: [String: String]?
    let first_verse_id: Int?
    let last_verse_id: Int?
    let verses_count: Int?
}
