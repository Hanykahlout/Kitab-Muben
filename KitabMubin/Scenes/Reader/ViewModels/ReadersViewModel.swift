//
//  ReadersViewModel.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 25/10/2022.
//

import Foundation

class ReadersViewModel {
    var dataSource: [ReaderData]?
    var viewModels: [ReaderViewModel] = [ReaderViewModel]()
    var filterdViewModels: [ReaderViewModel]?
    
    init(dataSource: [ReaderData]) {
        self.dataSource = dataSource
        updateModels()
    }
    
    func updateModels(){
        setupViewModels()
        self.filterdViewModels = viewModels
    }
    
    private func setupViewModels() {
        viewModels.removeAll()
        dataSource?.forEach { model in
            viewModels.append(ReaderViewModel(entity: model))
        }
    }
    
    public func appendViewModels(vm: [ReaderViewModel]) {
        viewModels.append(contentsOf: vm)
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
    
    func dataSource(for indexPath: IndexPath) -> ReaderViewModel {
        return viewModels[indexPath.row]
    }
    
    func dataSourceForFilterd(for indexPath: IndexPath) -> ReaderViewModel? {
        return filterdViewModels?[indexPath.row]
    }

    func didSelectRow(at indexPath: IndexPath) -> ReaderViewModel {
        return viewModels[indexPath.row]
    }
}




