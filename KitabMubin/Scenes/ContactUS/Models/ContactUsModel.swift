//
//  ContactUsModel.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 04/11/2022.
//

import Foundation

struct ContactUsModel: Decodable {
    let status: Bool?
    let data: ContactModel?
    let messages: [String?]
    let code: Int?
}

struct ContactModel: Decodable {
    let name: String?
    let email: String?
    let msg: String?
    let created_at: String?
    let id: Int?
}
