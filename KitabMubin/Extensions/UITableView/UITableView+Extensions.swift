//
//  UITableView+Extensions.swift
//  KitabMubin
//
//  Created by MoamenHalanMac on 24/07/2022.
//

import UIKit

extension UITableView {
    
    /**
     * Call when you need to register UITableViewCell CellNib
     * - parameter cellClass: UITableViewCell Calss
     */
    func registerCellNib<Cell: UITableViewCell>(cellClass: Cell.Type) {
        self.register(UINib(nibName: String(describing: Cell.self), bundle: nil), forCellReuseIdentifier: String(describing: Cell.self))
    }
    
    /**
     * Call when you need to dequeue UITableViewCell and you can casting to any UITableViewCell
     */
    func dequeue<Cell: UITableViewCell>() -> Cell {
        let identifier = String(describing: Cell.self)
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier) as? Cell else {
            fatalError("Error in cell") // this line for me as adevloper no a user to help me to know where is a problem becuse it block my code in this line to help me to detecte where is a problem
        }
        return cell
    }
    
}
