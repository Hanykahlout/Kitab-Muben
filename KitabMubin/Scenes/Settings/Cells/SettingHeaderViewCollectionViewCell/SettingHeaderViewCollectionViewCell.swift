//
//  SettingHeaderViewCollectionViewCell.swift
//  KitabMubin
//
//  Created by MoamenHalanMac on 06/08/2022.
//

import UIKit

class SettingHeaderViewCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlet's
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var settingImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupAppearance()
    }
    
    // MARK: - Properties
    var dataSource: SettingDataModel? {
        didSet {
            prepareData(with: dataSource)
        }
    }
    
    // MARK: - Methods
    private func setupAppearance() {
        containerView.addCornerRadius(8)
    }
    
    private func prepareData(with dataModel: SettingDataModel?) {
        guard let dataModel = dataModel else { return }
        settingImage.image = UIImage(named: dataModel.settingIconName ?? "")
        titleLabel.text = dataModel.settingTitle
    }
}
