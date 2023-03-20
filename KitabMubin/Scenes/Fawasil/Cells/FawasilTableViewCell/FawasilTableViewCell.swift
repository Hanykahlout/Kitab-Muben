//
//  FawasilTableViewCell.swift
//  KitabMubin
//
//  Created by MoamenHalanMac on 06/08/2022.
//

import UIKit

class FawasilTableViewCell: UITableViewCell {
    
    // MARK: - Outlet's
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    // MARK: - Properties
    var dataSource: BookmarkViewModel? {
        willSet {
            guard let newValue = newValue else { return }
            configure(with: newValue)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupAppearance()
    }
    
    // MARK: - Methods
    private func setupAppearance() {
        containerView.addCornerRadius(8)
    }
    
    // MARK: - Methods
    private func configure(with viewModel: BookmarkViewModel?) {
        titleLabel.text = viewModel?.title
        detailsLabel.text = "رقم الصفحة: \(viewModel?.pageNumber ?? 0)"
    }
}
