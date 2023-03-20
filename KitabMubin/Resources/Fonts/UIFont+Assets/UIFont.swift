//
//  UIFont.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 23/10/2022.
//

import UIKit



public class Fonts {
    public class func registerFonts() {
        UIFont.registerFont(bundle: .main, fontName: "", fontExtension: "ttf")
        UIFont.registerFont(bundle: .main, fontName: "", fontExtension: "ttf")
        UIFont.registerFont(bundle: .main, fontName: "", fontExtension: "ttf")
    }
}

extension UIFont {
    @discardableResult static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) -> Bool {
        
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension) else {
            fatalError("Couldn't find font \(fontName)")
        }
        
        guard let fontDataProvider = CGDataProvider(url: fontURL as CFURL) else {
            fatalError("Couldn't load data from the font \(fontName)")
        }
        
        guard let font = CGFont(fontDataProvider) else {
            fatalError("Couldn't create font from data")
        }
        
        var error: Unmanaged<CFError>?
        let success = CTFontManagerRegisterGraphicsFont(font, &error)
        guard success else {
            print("Error registering font: maybe it was already registered.")
            return false
        }
        return true
    }
}
