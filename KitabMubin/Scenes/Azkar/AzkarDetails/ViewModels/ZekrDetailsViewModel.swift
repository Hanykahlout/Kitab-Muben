//
//  ZekrDetailsViewModel.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 06/12/2022.
//

import Foundation

class ZekrDetailsViewModel {
    var title: String?
    var subtitle: String?
    var times: String?
    
    init(dataSource: AzkarDescription) {
        self.title = dataSource.title
        self.subtitle = dataSource.text
        self.times = dataSource.times
    }
}
