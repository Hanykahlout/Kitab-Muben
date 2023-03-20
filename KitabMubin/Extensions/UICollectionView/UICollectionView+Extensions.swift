//
//  UICollectionView+Extensions.swift
//  KitabMubin
//
//  Created by MoamenHalanMac on 24/07/2022.
//

import UIKit

extension UICollectionView {
    
    /**
     * Call when you need to register UICollectionViewCell CellNib
     * - parameter cellClass: UITableViewCell Calss
     */
    func registerCellNib<Cell: UICollectionViewCell>(cellClass: Cell.Type) {
        self.register(UINib(nibName: String(describing: Cell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: Cell.self))
    }
    
    /**
     * Call when you need to register UICollectionViewCell CellNib
     * - parameter indexPath: Your cell IndexPath
     * - return dequeued UICollectionViewCell and you can casting to any UICollectionViewCell
     */
    func dequeue<Cell: UICollectionViewCell>(indexPath: IndexPath) -> Cell {
        let identifier = String(describing: Cell.self)
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? Cell else {
            fatalError("Error in cell")
        }
        return cell
    }
    
}
