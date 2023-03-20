//
//  AzkarDetailsTableViewCell.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 31/10/2022.
//

import UIKit

class AzkarDetailsTableViewCell: UITableViewCell {
        
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var timesLabel: UILabel!
    
    var dataSource: ZekrDescriptionModel? {
        willSet {
            guard let newValue = newValue else { return }
            configure(for: newValue)
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        setupAppearance()
    }
    
    private func setupAppearance() {
        selectionStyle = .none
        separatorInset = .zero
        descLabel.font = UIFont(name: "KFGQPCHAFSUthmanicScript-Regula", size: 26)
        titleLabel.font = UIFont(name: "Tajawal-Medium", size: 26)
        timesLabel.font = UIFont(name: "Tajawal-Medium", size: 20)
        titleLabel.textColor = .KMGreanBackGround
        descLabel.textColor = .KMTextColor
        timesLabel.textColor = .KMGreanBackGround
    }
    
    func configure(for viewModel: ZekrDescriptionModel) {
        titleLabel.text = viewModel.title
        descLabel.text = viewModel.text
        timesLabel.text = viewModel.times
    }
}
