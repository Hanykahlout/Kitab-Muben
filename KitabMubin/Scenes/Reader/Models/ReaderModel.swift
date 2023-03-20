//
//  ReaderModel.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 24/10/2022.
//

import Foundation

struct ReaderModel: Decodable {
    let readerDetails: ReaderDetails?
    
    enum CodingKeys: String, CodingKey {
        case readerDetails = "data"
    }
}

struct ReaderDetails: Decodable {
    let currentPage: Int?
    let readerData: [ReaderData]?
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

struct ReaderData: Decodable {
    let id: Int?
    let name: String?
    let reading: String?
    let image: String?
    let createdAt: String?
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, reading, image
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct Link: Decodable {
    let url: String?
    let label: String?
    let active: Bool?
}
