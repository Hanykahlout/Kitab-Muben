//
//  UIButton+Extensions.swift
//  BunYankm
//
//  Created by hady on 22/04/2022.
//

import UIKit

extension UIButton{
    
    func underline() {
        
        let attrs = [NSAttributedString.Key.underlineStyle : 1]
        
        let attributedString = NSMutableAttributedString(string: "")
        
        let buttonTitleStr = NSMutableAttributedString(string: self.titleLabel?.text ?? "", attributes: attrs)
        attributedString.append(buttonTitleStr)
        self.setAttributedTitle(attributedString, for: .normal)
        
    }
    
}
