//
//  AboutAppModel.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 02/11/2022.
//

import Foundation

struct AboutAppModel: Decodable {
    
    let status: Bool?
    let data: AboutData?
    let messages: [String?]
    let code: Int?
    
}

struct AboutData: Decodable {
    let id: Int?
    let desc_en: String?
    let desc_ar: String?
    let title_ar: String?
    let title_en: String?
    let media_path: String?
}
