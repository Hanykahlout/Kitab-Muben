//
//  ReaderDetailsViewModel.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 15/11/2022.
//

import Foundation

class ReaderDetailsViewModel {
    var dataSource: [ReaderDetailsData]?
    var viewModels: [ReaderDetailCellViewModel] = [ReaderDetailCellViewModel]()
    var filteredViewModels: [ReaderDetailCellViewModel]?
    
    init(dataSource: [ReaderDetailsData]) {
        self.dataSource = dataSource
        updateModels()
    }
    
    func updateModels(){
        filteredViewModels = []
        viewModels = []
        setupViewModels()
        filteredViewModels = viewModels
    }
    
    private func setupViewModels() {
        dataSource?.forEach({ model in
            viewModels.append(ReaderDetailCellViewModel(dataSource: model, isDonwloaded: false))
        })
    }
    
    var numberOfRowsInSection: Int {
        return filteredViewModels?.count ?? 0
    }
    
    var numberOfSections: Int {
        return 1
    }
    
    var headerHeight: CGFloat {
        return 56
    }
    
    func dataSource(for indexPath: IndexPath) -> ReaderDetailCellViewModel {
        return viewModels[indexPath.row]
    }
    
    func dataSourceForFiltered(for indexPath: IndexPath) -> ReaderDetailCellViewModel? {
        return filteredViewModels?[indexPath.row]
    }

    func didSelectRow(at indexPath: IndexPath) -> ReaderDetailCellViewModel {
        return viewModels[indexPath.row]
    }
}
