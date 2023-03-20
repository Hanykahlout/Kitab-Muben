//
//  ReaderTableViewCell.swift
//  KitabMubin
//
//  Created by MoamenHalanMac on 08/08/2022.
//

import UIKit
import SDWebImage

protocol AzkarTableViewCellDelegate: AnyObject {
    func notificationTapped(model:ZekrModel?)
}

class AzkarTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var azkarNameLabel: UILabel!
    @IBOutlet weak var notificationTime: UILabel!
    @IBOutlet weak var notificationImage: UIImageView!
    
    // MARK: - Properties
    var dataSource: ZekrModel? {
        willSet {
            guard let newValue = newValue else { return }
            configure(for: newValue)
        }
    }
    
    weak var delegate: AzkarTableViewCellDelegate?
        
    override func awakeFromNib() {
        super.awakeFromNib()
        setupAppearance()
    }
    
    // MARK: - Methods
    private func setupAppearance() {
        containerView.addCornerRadius(8)
        azkarNameLabel.textAlignment = .right
        azkarNameLabel.font = UIFont(name: "Tajawal-Bold", size: 16)
    }
    
    private func configure(for viewModel: ZekrModel?) {
        guard let viewModel = viewModel else { return }
        azkarNameLabel.text = viewModel.name
        notificationImage.image = (viewModel.notification_id != nil) ? UIImage(named: "notification_selected") : UIImage(named: "Noti-stop")
        
        notificationTime.isHidden = (viewModel.notification_id == nil)
        
        guard let date = viewModel.date else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .init(identifier: "en")
        dateFormatter.dateFormat = "h:m"
        notificationTime.text = dateFormatter.string(from: date)
        
    }
    
    @IBAction func notificationTapped(_ sender: UIButton) {
        delegate?.notificationTapped(model: dataSource)
    }
}
