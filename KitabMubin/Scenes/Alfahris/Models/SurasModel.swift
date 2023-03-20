//
//  SurasModel.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 21/10/2022.
//

import Foundation

struct SurasModel: Decodable {
    let chapters: [Chapter]?
}

struct Chapter: Decodable {
    let id: Int?
    let name: String?
    let verses_count: Int?
    let pages: [Int]?
}
