//
//  PhoneNumberModel.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 04/12/2022.
//

import Foundation

class PhoneNumberResponse: Decodable {
    let status: Bool?
    let data: [PhoneNumberEntity]?
    let messages: [String?]
    let code: Int?
}

class PhoneNumberEntity: Decodable {
    let value: String?
    let type: String?
    let image: String?
}
