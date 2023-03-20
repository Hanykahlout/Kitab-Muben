//
//  QuranModel.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 21/10/2022.
//

import Foundation

struct QuranModel: Decodable {
    let id: Int?
    let jozz: Int?
    let sura_no: Int?
    let sura_name_en: String?
    let sura_name_ar: String?
    let page: Int?
    let line_start: Int?
    let line_end: Int?
    let aya_no: Int?
    let aya_text: String?
    let aya_text_emlaey: String?
}
