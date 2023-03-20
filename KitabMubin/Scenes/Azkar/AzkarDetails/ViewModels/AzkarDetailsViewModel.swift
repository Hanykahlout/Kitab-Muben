//
//  AzkarDetailsViewModels.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 31/10/2022.
//

import Foundation

class AzkarDetailsViewModel {
    var viewModels: [ZekrDescriptionModel] = [ZekrDescriptionModel]()

    init(dataSource: [ZekrDescriptionModel]) {
        viewModels = dataSource
    }
    
    func dataSource(for indexPath: IndexPath) -> ZekrDescriptionModel {
        return viewModels[indexPath.row]
    }

    var numberOfRowsInSection: Int {
        return viewModels.count
    }

    var numberOfSections: Int {
        return 1
    }
    
    var title: String?
}
