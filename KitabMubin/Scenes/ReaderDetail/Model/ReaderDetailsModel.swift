//
//  ReaderDetailsModel.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 14/11/2022.
//

import Foundation

struct ReaderDetailsResponse: Decodable {
    let readerDetails: ReaderDetailsModel?
    
    enum CodingKeys: String, CodingKey {
        case readerDetails = "data"
    }
}

struct ReaderDetailsModel: Decodable {
    let currentPage: Int?
    let readerData: [ReaderDetailsData]?
    let firstPageUrl: String?
    let from: Int?
    let lastPage: Int?
    let lastPageUrl: String?
    let links: [Link]?
    let nextPageUrl: String?
    let path: String?
    let perPage: Int?
    let prevPageUrl: String?
    let to: Int?
    let total: Int?
    
    enum CodingKeys: String, CodingKey {
        case readerData = "data"
        case currentPage = "current_page"
        case firstPageUrl = "first_page_url"
        case lastPage = "last_page"
        case lastPageUrl = "last_page_url"
        case nextPageUrl = "next_page_url"
        case perPage = "per_page"
        case prevPageUrl = "prev_page_url"
        case from, links, path, to, total
    }
}

struct ReaderDetailsData: Decodable {
    let id: Int?
    let reciter_id: String?
    let sura_id: String?
    let sura_num: String?
    let sura_name: String?
    let reading: String?
    let audio_file: String?
}
