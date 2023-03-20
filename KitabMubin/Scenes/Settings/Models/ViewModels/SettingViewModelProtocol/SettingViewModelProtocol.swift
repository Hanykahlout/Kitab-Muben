//
//  SettingViewModelProtocol.swift
//  KitabMubin
//
//  Created by MoamenHalanMac on 06/08/2022.
//

import UIKit

protocol SettingViewModelProtocol {
    var numberOfRowsInSection: Int { get }
    var numberOfSection: Int { get }
    var minimumLineSpacing: CGFloat { get }
    var minimumInteritemSpacing: CGFloat { get }
    var headerHeight: CGFloat { get }
    func dataSourceForIndex(at indexPath: IndexPath) -> SettingDataModel
    func didSelectItem(at indexPath: IndexPath) -> SettingDataModel
    func calculateCellSize(collectionView: UICollectionView) -> CGSize
}

extension SettingViewModelProtocol {
    var minimumLineSpacing: CGFloat {
        return 0
    }
    
    var minimumInteritemSpacing: CGFloat {
        return 0
    }
    
    var headerHeight: CGFloat {
        return 0
    }
    
    func calculateCellSize(collectionView: UICollectionView) -> CGSize {
        return .zero
    }
}
