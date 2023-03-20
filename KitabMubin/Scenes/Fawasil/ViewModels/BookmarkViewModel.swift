//
//  BookmarkViewModel.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 28/11/2022.
//

import Foundation

class BookmarkViewModel {
    var title: String?
    var subtitle: String?
    var pageNumber : Int?
    init(title: String? = nil, subtitle: String? = nil, pageNumber: Int? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.pageNumber = pageNumber
    }
}
