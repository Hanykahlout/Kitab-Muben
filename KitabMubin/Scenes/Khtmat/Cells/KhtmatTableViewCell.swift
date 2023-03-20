//
//  KhtmatTableViewCell.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 25/11/2022.
//

import UIKit

class KhtmatTableViewCell: UITableViewCell {
    
    var dataSource: KhtmaViewModel? {
        willSet {
            guard let newValue = newValue else { return }
            configure(for: newValue)
        }
    }
    
    @IBOutlet weak var khtmaTitle: UILabel!
    @IBOutlet weak var khtmaDate: UILabel!
    @IBOutlet weak var khtmaStatus: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var khtmaStatusContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupAppearance()
    }
    
    // MARK: - Methods
    private func setupAppearance() {
        selectionStyle = .none
        containerView.addCornerRadius(8)
        khtmaStatusContainer.addCornerRadius(8)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func configure(for viewModel: KhtmaViewModel) {
        khtmaTitle.text = viewModel.name
        khtmaStatus.text = viewModel.completed ?? false ? "مكتملة" : "غير مكتملة"
        khtmaStatusContainer.backgroundColor = viewModel.completed ?? false ? UIColor.KMGreanBackGround : UIColor.KMPlaceHolderTextColor1
        khtmaDate.attributedText = dateAttributedText(date: viewModel.date ?? Date())
    }
    
    private func hjiriDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        let hijriCalendar = Calendar.init(identifier: Calendar.Identifier.islamicCivil)
        dateFormatter.locale = Locale.init(identifier: "ar")
        dateFormatter.calendar = hijriCalendar
        dateFormatter.dateFormat = "EEEE, dd MMMM, yyyy"
        return dateFormatter.string(from: date)
    }
    
    private func dateAttributedText(date: Date) -> NSMutableAttributedString {
        let startText = "بدأت في "
        let endText = hjiriDate(date: date)
        let string = startText+endText
        let attributedText = NSMutableAttributedString(string: string)
        let firstRange = NSRange(location: 0, length: startText.count)
        let secondRange = NSRange(location: startText.count, length: endText.count)
        attributedText.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.KMTextColor, .font : UIFont(name: "Tajawal-Medium", size: 15) ?? UIFont()], range: firstRange)
        attributedText.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.KMPlaceHolderTextColor1, .font : UIFont(name: "Tajawal-Medium", size: 15) ?? UIFont()], range: secondRange)
        return attributedText
    }
}
