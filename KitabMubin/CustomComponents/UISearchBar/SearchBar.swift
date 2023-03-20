//
//  SearchBar.swift
//  KitabMubin
//
//  Created by MoamenHalanMac on 05/08/2022.
//

import UIKit

public class SearchBar: UISearchBar {
    
    // MARK: - Properties
    private var radius:  CGFloat = 8.0
    private var textFieldHeight: CGFloat = 48
    
    public init(textFieldHeight: CGFloat = 48, radius: CGFloat = 8.0) {
        super.init(frame: .zero)
        self.radius = radius
        self.textFieldHeight = textFieldHeight
        setupSearchBarAppearance()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSearchBarAppearance()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSearchBarAppearance()
    }
    
    private func setupSearchBarAppearance() {
        setupSearchBarImages()
        setupTextField()
        setTextPositionAdjustment()
        setTextFieldHeight()
    }
    
    private func setupSearchBarImages() {
        searchBarStyle = .minimal
        setImage(UIImage(named: "search_icon"), for: .search, state: .normal)
    }
    
    private func setupTextField(){
        let font = UIFont(name: "Tajawal-Medium", size: 13)
        if #available(iOS 13.0, *) {
            searchTextField.font = font
            searchTextField.backgroundColor = .KMBackgroundLight1
            searchTextField.textColor = .KMTextColor
            searchTextField.tintColor = .KMTextColor
            searchTextField.layer.cornerRadius = radius
            searchTextField.layer.masksToBounds = true
            searchTextField.textAlignment = .right
            setPlaceholderText()
        } else {
            textField?.font = font
            textField?.backgroundColor = .KMBackgroundLight1
            textField?.textColor = .KMTextColor
            textField?.tintColor = .KMTextColor
            textField?.layer.cornerRadius = radius
            textField?.layer.masksToBounds = true
            textField?.textAlignment = .right
            setPlaceholderText()
        }
    }
    
    /**
     * Call when you need to change searchBar Style
     * - parameter style: Searchbar style
     */
    private func setSearchBarStyle(style: UISearchBar.Style = .minimal) {
        searchBarStyle = style
    }
    
    /**
     * Call when you need to change textField placeholder text
     * - parameter placeholer: The search textField placeholer
     */
    public func setPlaceholderText(placeholer: String = "Search") {
        if #available(iOS 13.0, *) {
            searchTextField.attributedPlaceholder =  NSAttributedString.init(string: placeholer, attributes: [NSAttributedString.Key.foregroundColor: UIColor.KMPlaceHolderTextColor])
        } else {
            textField?.attributedPlaceholder =  NSAttributedString.init(string: placeholer, attributes: [NSAttributedString.Key.foregroundColor: UIColor.KMPlaceHolderTextColor])
        }
    }
    
    /**
     * Call when you need to change search image icon
     * - parameter searchIcon: The search image icon
     */
    private func setSearchImage(searchIcon: UIImage? = UIImage(named: "search_icon")){
        setImage(searchIcon, for: .search, state: .normal)
    }
    
    /**
     * Call when you need to change clear search button image icon
     * - parameter clearIcon: The clear search button image icon
     */
    private func setClearImage(clearIcon: UIImage? = UIImage(named: "ecoclose_Icon")){
        setImage(clearIcon, for: .clear, state: .normal)
    }
    
    /**
     * Call when you need to change text position
     * - parameter position: The search text position adjustment
     */
    private func setTextPositionAdjustment(position: UIOffset = UIOffset(horizontal: 8, vertical: 2)){
        searchTextPositionAdjustment = position
    }
    
    private func setTextFieldHeight() {
        let image = UIImage.createColorImage(color: .KMBackgroundLight1, size: CGSize(width: 1, height: textFieldHeight))
        setSearchFieldBackgroundImage(image, for: .normal)
    }
}
