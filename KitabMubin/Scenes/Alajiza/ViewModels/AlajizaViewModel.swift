//
//  AlajizaViewModel.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 23/10/2022.
//

import Foundation

class AlajizaViewModel {
    
    private var dataSource: [JuzsModel]?
    var viewModels: [JuzsViewModel] = [JuzsViewModel]()
    var filterdViewModels: [JuzsViewModel]?
    
    init(dataSource: [JuzsModel]) {
        self.dataSource = dataSource
        setupViewModels()
        self.filterdViewModels = viewModels
    }
    
    private func setupViewModels() {
        dataSource?.forEach { model in
            viewModels.append(JuzsViewModel(entity: model))
        }
    }
    
    var numberOfRowsInSection: Int {
        return filterdViewModels?.count ?? 0
    }
    
    var numberOfSections: Int {
        return 1
    }
    
    var headerHeight: CGFloat {
        return 56
    }
    
    func dataSource(for indexPath: IndexPath) -> JuzsViewModel {
        return viewModels[indexPath.row]
    }
    
    func dataSourceForFiltered(for indexPath: IndexPath) -> JuzsViewModel? {
        return filterdViewModels?[indexPath.row]
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        for viewModel in viewModels {
            viewModel.isSelected = false
        }
        viewModels[indexPath.row].isSelected = true
    }
}
