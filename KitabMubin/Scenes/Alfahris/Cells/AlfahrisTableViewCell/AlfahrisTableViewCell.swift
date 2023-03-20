//
//  AlfahrisTableViewCell.swift
//  KitabMubin
//
//  Created by MoamenHalanMac on 05/08/2022.
//

import UIKit

protocol AlfahrisTableViewCellDelegate: AnyObject {
    
}

class AlfahrisTableViewCell: UITableViewCell {

    // MARK: - Outlet's
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var countContainerView: UIView!
    @IBOutlet weak var countLabel: UILabel!
    
    // MARK: - Properties
    var dataSource: SuraViewModel? {
        willSet {
            guard let newValue = newValue else { return }
            configure(for: newValue)
        }
    }
    
    weak var delegate: AlfahrisTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupAppearance()
        
    }
    
    // MARK: - Methods
    private func setupAppearance() {
        titleLabel.textAlignment = .right
        detailsLabel.textAlignment = .right
        containerView.addCornerRadius(8)
        countContainerView.addCornerRadius(20)
    }
    
    // MARK: - Methods
    private func configure(for viewModel: SuraViewModel?) {
        titleLabel.text = viewModel?.suraName
        detailsLabel.text = "رقمها \(viewModel?.suraId ?? 0), آياتها \(viewModel?.versesCount ?? 0)"
        countLabel.text = "\(viewModel?.suraId ?? 0)"
        containerView.backgroundColor = (viewModel?.isSelected ?? false) ? .KMUnGreanBackGround : .KMBackgroundLight1
    }
}
