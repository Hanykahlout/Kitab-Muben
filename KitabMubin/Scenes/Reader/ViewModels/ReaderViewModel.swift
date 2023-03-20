//
//  ReaderViewModel.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 24/10/2022.
//

import Foundation

class ReaderViewModel {
    private(set) var imageURL: String?
    private(set) var readerName: String?
    private(set) var reading: String?
    private(set) var id: Int?
    
    init(entity: ReaderData) {
        imageURL = entity.image
        readerName = entity.name
        reading = entity.reading
        id = entity.id
    }
}
