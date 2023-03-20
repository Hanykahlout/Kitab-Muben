//
//  FeaturesViewModel.swift
//  KitabMubin
//
//  Created by MoamenHalanMac on 05/08/2022.
//

import UIKit

protocol FeaturesViewModelProtocol {
    var selectedFeatureItem: FeatureDataModel? { get }
    var numberOfRowsInSection: Int { get }
    var numberOfSection: Int { get }
    var minimumLineSpacing: CGFloat { get }
    var minimumInteritemSpacing: CGFloat { get }
    func dataSourceForIndex(at indexPath: IndexPath) -> FeatureDataModel
    func calculateCellSize(collectionView: UICollectionView) -> CGSize
    func didSelectItem(at indexPath: IndexPath)
}

class FeaturesViewModel: FeaturesViewModelProtocol {
    
    var selectedFeatureItem: FeatureDataModel?
    var featuresDataSource: [FeatureDataModel] = []
    
    init(selectedItem: FeatureDataModel? = nil) {
        self.selectedFeatureItem = selectedItem
        setupDataSource()
    }
    
    var numberOfRowsInSection: Int {
        return featuresDataSource.count
    }
    
    var numberOfSection: Int {
        return 1
    }
    
    var minimumLineSpacing: CGFloat {
        return 40
    }
    
    var minimumInteritemSpacing: CGFloat {
        return 40
    }
    
    private func setupDataSource() {
        featuresDataSource.append(FeatureDataModel(featureTitle: "الأدوات", featureId: "Feature_Four", featureIconName: "setting_icon", isSelectedItem: false))

        featuresDataSource.append(FeatureDataModel(featureTitle: "الفواصل", featureId: "Feature_Three", featureIconName: "fawasil_icon", isSelectedItem: false))
        
        featuresDataSource.append(FeatureDataModel(featureTitle: "الأجزاء", featureId: "Feature_Two", featureIconName: "parts_icon", isSelectedItem: false))

        featuresDataSource.append(FeatureDataModel(featureTitle: "الفهرس", featureId: "Feature_One", featureIconName: "alfahris_icon", isSelectedItem: true))

        if selectedFeatureItem == nil {
            selectedFeatureItem = featuresDataSource[3]
        }
        setupSelectedSortItem()
    }
    
    private func setupSelectedSortItem() {
        guard let selectedItem = selectedFeatureItem else { return }
        for index in 0..<featuresDataSource.count {
            if featuresDataSource[index].featureId == selectedItem.featureId {
                featuresDataSource[index].isSelectedItem = true
            } else {
                featuresDataSource[index].isSelectedItem = false
            }
        }
    }
    
    func dataSourceForIndex(at indexPath: IndexPath) -> FeatureDataModel {
        let viewModel = featuresDataSource[indexPath.row]
        return viewModel
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        selectedFeatureItem = featuresDataSource[indexPath.row]
        selectedFeatureItem?.isSelectedItem = true
        setupSelectedSortItem()
    }
    
    func calculateCellSize(collectionView: UICollectionView) -> CGSize {
        let width = (collectionView.frame.width - 40) / 4
        return CGSize(width: width, height: width)
    }
    
}
