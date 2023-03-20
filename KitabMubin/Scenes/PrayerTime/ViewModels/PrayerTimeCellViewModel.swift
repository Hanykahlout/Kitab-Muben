//
//  PrayerTimeCellViewModel.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 09/11/2022.
//

import Foundation

class PrayerTimeCellViewModel {
    var title: String?
    var subtitle: String?
    var iconName: String?
    
    init(title: String? = nil, subtitle: String? = nil, iconName: String? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.iconName = iconName
    }
}
