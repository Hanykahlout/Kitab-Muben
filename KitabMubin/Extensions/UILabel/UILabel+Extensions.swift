//
//  UILabel+Extensions.swift
//  BunYankm
//
//  Created by Moamen Abd Elgawad on 21/04/2022.
//

import UIKit

extension UILabel{
    
    func underline() {
        guard let text = self.text else { return }
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
        
        self.attributedText = attributedString
    }
    
}
