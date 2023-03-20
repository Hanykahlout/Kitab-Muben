//
//  ReaderTableViewCell.swift
//  KitabMubin
//
//  Created by MoamenHalanMac on 08/08/2022.
//

import UIKit
import SDWebImage

class ReaderTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var readerNameLabel: UILabel!
    @IBOutlet weak var readingLabel: UILabel!
    @IBOutlet weak var readerImage: UIImageView!
    @IBOutlet weak var arrowImage: UIImageView!
    
    // MARK: - Properties
    var dataSource: ReaderViewModel? {
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
        readerNameLabel.textAlignment = .right
        readingLabel.textAlignment = .right
        arrowImage.image = UIImage(named: "arrow_icon")!.flippedImage()
    }
    
    private func configure(for viewModel: ReaderViewModel?) {
//        readingLabel.text = viewModel?.reading
        readerNameLabel.text = viewModel?.readerName
        let imageURL = "http://api.kitabmuben.com/\(viewModel?.imageURL ?? "")"
        readerImage.sd_setImage(with: URL(string: (imageURL)),placeholderImage: UIImage(named: "reader_image"))
    }
}



