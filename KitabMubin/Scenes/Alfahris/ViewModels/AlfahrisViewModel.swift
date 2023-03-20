//
//  AlfahrisViewModel.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 22/10/2022.
//

import Foundation

class AlfahrisViewModel {
    
    private var dataSource: [Chapter]?
    var viewModels: [SuraViewModel] = [SuraViewModel]()
    var filterViewModels: [SuraViewModel]?
    
    init(dataSource: [Chapter]) {
        self.dataSource = dataSource
        setupViewModels()
        filterViewModels = viewModels
    }
    
    
    private func setupViewModels() {
        dataSource?.forEach { model in
            viewModels.append(SuraViewModel(entity: model))
        }
    }
    
    var numberOfRowsInSection: Int {
        return filterViewModels?.count ?? 0
    }
    
    var numberOfSections: Int {
        return 1
    }
    
    var headerHeight: CGFloat {
        return 56
    }
    
    func dataSource(for indexPath: IndexPath) -> SuraViewModel {
        return viewModels[indexPath.row]
    }
    
    func dataSourceForFiltered(for indexPath: IndexPath) -> SuraViewModel? {
        return filterViewModels?[indexPath.row]
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        for viewModel in viewModels {
            viewModel.isSelected = false
        }
        viewModels[indexPath.row].isSelected = true
    }
}
