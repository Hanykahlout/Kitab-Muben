//
//  SuraViewModel.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 22/10/2022.
//

import Foundation

class SuraViewModel {
    
    private(set) var suraName: String?
    private(set) var suraId: Int?
    private(set) var versesCount: Int?
    var firstPage: Int?
    var isSelected: Bool
    
    init(entity: Chapter, isSelected: Bool = false) {
        suraName = entity.name
        suraId = entity.id
        versesCount = entity.verses_count
        firstPage = entity.pages?[0]
        self.isSelected = isSelected
    }
}
