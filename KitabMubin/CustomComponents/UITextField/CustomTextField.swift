//
//  CustomTextField.swift
//  KitabMubin
//
//  Created by Moamen Abd Elgawad on 17/08/2022.
//

import UIKit

class CustomTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //setupTextField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //setupTextField()
    }
    
    override func awakeFromNib() {
        
        font = UIFont(name: "Tajawal-Medium", size: 16)
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.KMTextColor,
            NSAttributedString.Key.font : UIFont(name: "Tajawal-Medium", size: 16) ?? UIFont()
        ]
        attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: attributes)
        addCornerRadius(10)
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12))
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12))
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12))
    }
    
    
    
}
