//
//  UISearchBar+Extensions.swift
//  KitabMubin
//
//  Created by MoamenHalanMac on 05/08/2022.
//

import UIKit

extension UISearchBar {
    /// Return text field inside a search bar
    public var textField: UITextField? {
        if #available(iOS 13, *) {
            return searchTextField
        }
        let subViews = subviews.flatMap { $0.subviews }
        guard let textField = (subViews.filter { $0 is UITextField }).first as? UITextField else {
            return nil
        }
        return textField
    }
}
