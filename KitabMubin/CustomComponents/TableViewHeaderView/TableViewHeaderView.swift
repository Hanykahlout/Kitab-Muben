//
//  TableViewHeaderView.swift
//  KitabMubin
//
//  Created by MoamenHalanMac on 05/08/2022.
//

import UIKit

class TableViewHeaderView: UITableViewHeaderFooterView {
    // MARK: - Outlet's
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!

    // MARK: - Properties
    var dataSource: String? {
        didSet {
            prepareData(with: dataSource)
        }
    }

    // MARK: - Methods
    private func prepareData(with title: String?) {
        titleLabel.text = title
        titleLabel.textAlignment = .right
    }
}
