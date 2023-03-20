//
//  BaseResponse.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 06/11/2022.
//

import Foundation

struct BaseResponse<T: Decodable> {
    var status: Bool?
    var code: Int?
    var messages: String?
    var data: T?
}
