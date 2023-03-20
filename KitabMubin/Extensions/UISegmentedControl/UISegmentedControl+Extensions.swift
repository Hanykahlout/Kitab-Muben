//
//  UISegmentedControl+Extensions.swift
//  KitabMubin
//
//  Created by MoamenHalanMac on 06/08/2022.
//

import UIKit

extension UISegmentedControl {
    func highlightSelectedSegment(){
        let font = UIFont(name: "Tajawal-Medium", size: 15) ?? UIFont()
        let background = UIImage.createColorImage(color: .KMBackgroundLight2, size: bounds.size)
        let selectedBackground = UIImage.createColorImage(color: .KMWhiteBackGround, size: bounds.size)
        setBackgroundImage(background, for: .normal, barMetrics: .default)
        setBackgroundImage(selectedBackground, for: .selected, barMetrics: .default)
        setBackgroundImage(selectedBackground, for: .highlighted, barMetrics: .default)
        setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.KMPlaceHolderTextColor, NSAttributedString.Key.font: font], for: .normal)
        setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.KMTextColor, NSAttributedString.Key.font: font], for: .selected)
    }
}
