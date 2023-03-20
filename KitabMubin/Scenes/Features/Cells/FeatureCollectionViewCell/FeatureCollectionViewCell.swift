//
//  FeatureCollectionViewCell.swift
//  KitabMubin
//
//  Created by MoamenHalanMac on 05/08/2022.
//

import UIKit

class FeatureCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlet
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var featureImageIcon: UIImageView!
    @IBOutlet weak var featureTitleLabel: UILabel!
  
    // MARK: - DataSource
    var dataSource: FeatureDataModel? {
        didSet {
            prepareData(with: dataSource)
        }
    }
    
    //MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupAppearance()
    }
    
    // MARK: - Method's
    func setupAppearance() {
        containerView.addCornerRadius()
    }
    
    private func prepareData(with dataModel: FeatureDataModel?) {
        guard let dataModel = dataModel else { return }
        featureImageIcon.image = UIImage(named: dataModel.featureIconName ?? "")
        featureTitleLabel.text = dataModel.featureTitle
        containerView.backgroundColor = dataModel.isSelectedItem ? .KMGreanBackGround : .KMDisabledBackGround
        featureTitleLabel.textColor = dataModel.isSelectedItem ? .KMGreanBackGround : .KMDisabledBackGround
    }

}
