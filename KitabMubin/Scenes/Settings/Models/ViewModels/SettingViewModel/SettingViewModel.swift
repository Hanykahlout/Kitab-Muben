//
//  SettingViewModel.swift
//  KitabMubin
//
//  Created by MoamenHalanMac on 06/08/2022.
//

import UIKit

class SettingViewModel: SettingViewModelProtocol {
    
    var dataSource: [SettingDataModel] = []
    
    init() {
        setupDataSource()
    }
    
    var numberOfRowsInSection: Int {
        return dataSource.count
    }
    
    var numberOfSection: Int {
        return 1
    }
    
    var headerHeight: CGFloat {
        return 100
    }
    
    private func setupDataSource() {
        dataSource.append(SettingDataModel(settingTitle: "أوقات الصلاة", settingId: "mosque", settingIconName: "mosque_icon"))
        dataSource.append(SettingDataModel(settingTitle: "القبلة", settingId: "compass", settingIconName: "compass_icon"))
        dataSource.append(SettingDataModel(settingTitle: "حول التطبيق", settingId: "aboutapp", settingIconName: "about_Icon"))
//        dataSource.append(SettingDataModel(settingTitle: "Device Theme", settingId: "devicetheme", settingIconName: "deviceTheme_icon"))
        dataSource.append(SettingDataModel(settingTitle: "تواصل معنا", settingId: "contuctus", settingIconName: "contuctUs_icon"))
        dataSource.append(SettingDataModel(settingTitle: "مشاركة التطبيق", settingId: "shareapp", settingIconName: "share_icon"))
        dataSource.append(SettingDataModel(settingTitle: "تقييم التطبيق", settingId: "rateapp", settingIconName: "rate_icon"))
    }
    
    func dataSourceForIndex(at indexPath: IndexPath) -> SettingDataModel {
        return dataSource[indexPath.row]
    }
    
    func didSelectItem(at indexPath: IndexPath) -> SettingDataModel {
        return dataSource[indexPath.row]
    }
}
