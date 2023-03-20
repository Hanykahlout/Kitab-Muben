//
//  PrayerTimeTableViewCell.swift
//  KitabMubin
//
//  Created by Moamen Abd Elgawad on 16/10/2022.
//

import UIKit

class PrayerTimeTableViewCell: UITableViewCell {
    
    // MARK: - Outlet's
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var prayerNameLabel: UILabel!
    @IBOutlet weak var prayerTimeLabel: UILabel!
    @IBOutlet weak var prayerImage: UIImageView!
    
    // MARK: - Properties
    var dataSource: PrayerTimeCellViewModel? {
        willSet {
            guard let newValue = newValue else { return }
            prepareData(with: newValue)
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
    
    private func prepareData(with dataModel: PrayerTimeCellViewModel?) {
        prayerNameLabel.text = dataModel?.title
        prayerTimeLabel.text = dataModel?.subtitle
        prayerImage.image = UIImage(named: dataModel?.iconName ?? "")
    }
}
