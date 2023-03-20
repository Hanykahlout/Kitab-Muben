//
//  AlajizaTableViewCell.swift
//  KitabMubin
//
//  Created by MoamenHalanMac on 05/08/2022.
//

import UIKit

class AlajizaTableViewCell: UITableViewCell {
    
    // MARK: - Outlet's
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    // MARK: - Properties
    var dataSource: JuzsViewModel? {
        willSet {
            guard let newValue = newValue else { return }
            configure(for: newValue)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupAppearance()
    }
    
    // MARK: - Methods
    private func setupAppearance() {
        containerView.addCornerRadius(8)
        titleLabel.textAlignment = .right
        detailsLabel.textAlignment = .right
    }
    
    // MARK: - Methods
    private func configure(for viewModel: JuzsViewModel?) {
        titleLabel.text = viewModel?.juzName
        detailsLabel.text = "الصفحه \(viewModel?.pageNumber ?? 0)"
        containerView.backgroundColor = (viewModel?.isSelected ?? false) ? .KMUnGreanBackGround : .KMBackgroundLight1
    }
}
