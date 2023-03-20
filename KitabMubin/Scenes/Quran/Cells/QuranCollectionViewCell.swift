//
//  QuranCollectionViewCell.swift
//  KitabMubin
//
//  Created by Hany Alkahlout on 22/01/2023.
//

import UIKit

class QuranCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainStack: UIStackView!
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    @IBOutlet weak var scrollToBottomButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        mainScrollView.delegate = self
        
    }
    
    func setDate(sure:[Sura]){
        mainStack.subviews.forEach({ $0.removeFromSuperview() })
        for sura in sure{
            let suraView = SuraView()
            suraView.suraNameLabel.text = "سورة \(sura.name)"
            suraView.suraTextLabel.text = sura.genrateSuraText()
            justifiedSuraText(suraTextLabel: suraView.suraTextLabel)
            suraView.basmalaLabel.isHidden = !sura.hasBasmala
            suraView.suraHeaderView.isHidden = !sura.hasBasmala
            mainStack.addArrangedSubview(suraView)
        }
        mainScrollView.layoutIfNeeded()
        checkScrollViewOffset()
    }
    
    
    private func justifiedSuraText(suraTextLabel:UILabel){
        let text: NSMutableAttributedString = NSMutableAttributedString(string: suraTextLabel.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .justified
        paragraphStyle.baseWritingDirection = .rightToLeft
        paragraphStyle.lineBreakMode = .byWordWrapping
        text.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, text.length))
        suraTextLabel.attributedText = text
    }
    
    
    @IBAction func scrollToBottomAction(_ sender: Any) {
        let bottomOffset = CGPoint(x: 0, y: mainScrollView.contentSize.height - mainScrollView.bounds.height + mainScrollView.contentInset.bottom)
        mainScrollView.setContentOffset(bottomOffset, animated: true)
    }
    
}


extension QuranCollectionViewCell: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        checkScrollViewOffset()
    }
    
    private func checkScrollViewOffset(){
        let contentHeight = mainScrollView.contentSize.height
        let contentOffset = mainScrollView.contentOffset.y
        let scrollViewHeight = mainScrollView.frame.size.height
        scrollToBottomButton.isHidden = (contentHeight - contentOffset) == scrollViewHeight
    }
}


