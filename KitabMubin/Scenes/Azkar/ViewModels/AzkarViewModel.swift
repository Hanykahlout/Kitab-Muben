//
//  AzkarViewModel.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 30/10/2022.
//

import Foundation

class AzkarViewModel {
    var viewModels: [ZekrModel] = [ZekrModel]()
    var filteredViewModels: [ZekrModel]?
    
    init(dataSource: [ZekrModel]) {
        viewModels = dataSource
        filteredViewModels = dataSource
    }

    var numberOfRowsInSection: Int {
        return filteredViewModels?.count ?? 0
    }
    
    var numberOfSections: Int {
        return 1
    }
    
    var rowHeight: CGFloat {
        return 70
    }
    
    func dataSource(for indexPath: IndexPath) -> ZekrModel {
        return viewModels[indexPath.row]
    }
    
    func dataSourceForFilter(for indexPath: IndexPath) -> ZekrModel? {
        return filteredViewModels?[indexPath.row]
    }
    
    
}
