//
//  SettingTableHeaderViewModel.swift
//  KitabMubin
//
//  Created by MoamenHalanMac on 06/08/2022.
//

import UIKit

class SettingTableHeaderViewModel: SettingViewModelProtocol {
    
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
    
    var minimumLineSpacing: CGFloat {
        return 16
    }
    
    var minimumInteritemSpacing: CGFloat {
        return 16
    }
    
    private func setupDataSource() {
        dataSource.append(SettingDataModel(settingTitle: "القراء", settingId: "readers", settingIconName: "reader_icon"))
        dataSource.append(SettingDataModel(settingTitle: "الختمات", settingId: "alkhatmat", settingIconName: "alkhatmat_icon"))
        dataSource.append(SettingDataModel(settingTitle: "الأذكار", settingId: "azkar", settingIconName: "azkar_icon"))
    }
    
    func dataSourceForIndex(at indexPath: IndexPath) -> SettingDataModel {
        return dataSource[indexPath.row]
    }
    
    func didSelectItem(at indexPath: IndexPath) -> SettingDataModel {
        return dataSource[indexPath.row]
    }
    
    func calculateCellSize(collectionView: UICollectionView) -> CGSize {
        let width = (collectionView.frame.width - 32) / 3
        return CGSize(width: width, height: 80)
    }
}
