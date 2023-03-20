//
//  QuranViewModel.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 21/10/2022.
//

import Foundation

class QuranViewModel {
    var suraName: String?
    var jozzNumber: Int?
    var pageNumber: Int?
    var suraContent: String?
    var hideBasmala: Bool
    var isSaved: Bool?
    init(suraName: String, jozzNumber: Int, pageNumber: Int, suraContent: String, hideBasmala: Bool,isSaved: Bool) {
        self.suraName = suraName
        self.pageNumber = pageNumber
        self.jozzNumber = jozzNumber
        self.suraContent = suraContent
        self.hideBasmala = hideBasmala
        self.isSaved = isSaved
    }
}
