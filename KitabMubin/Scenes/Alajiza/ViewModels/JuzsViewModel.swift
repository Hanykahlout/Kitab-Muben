//
//  JuzsViewModel.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 23/10/2022.
//

import Foundation

class JuzsViewModel {
    private(set) var juzName: String?
    private(set) var juzNumber: Int?
    var pageNumber: Int?
    var isSelected: Bool
    
    init(entity: JuzsModel, isSelected: Bool = false) {
        juzName = entity.juz_name
        juzNumber = entity.juz_number
        pageNumber = entity.page_number
        self.isSelected = isSelected
    }
}
