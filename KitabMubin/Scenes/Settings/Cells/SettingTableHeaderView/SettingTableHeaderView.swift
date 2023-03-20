//
//  SettingTableHeaderView.swift
//  KitabMubin
//
//  Created by MoamenHalanMac on 06/08/2022.
//

import UIKit

protocol SettingHeaderViewProtocol: AnyObject {
    func didSelectItem(item: SettingDataModel)
}

class SettingTableHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Outlet's
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    var delegate: SettingHeaderViewProtocol?
    var viewModel: SettingViewModelProtocol? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        assignDelegates()
        registerCells()
    }
    
    // MARK: - Methods
    private func assignDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func registerCells() {
        collectionView.registerCellNib(cellClass: SettingHeaderViewCollectionViewCell.self)
    }
}

extension SettingTableHeaderView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.numberOfSection ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfRowsInSection ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(indexPath: indexPath) as SettingHeaderViewCollectionViewCell
        cell.dataSource = viewModel?.dataSourceForIndex(at: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel?.calculateCellSize(collectionView: collectionView) ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel?.minimumLineSpacing ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel?.minimumInteritemSpacing ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let model = viewModel?.didSelectItem(at: indexPath) {
            delegate?.didSelectItem(item: model)
        }
    }
}
