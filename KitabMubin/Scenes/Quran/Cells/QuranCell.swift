//
//  QuranCell.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 14/11/2022.
//

import UIKit

class QuranCell: UICollectionViewCell {
    
    static let identifier = "QuranCell"
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.contentInsetAdjustmentBehavior = .never
        return scroll
    }()
    
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let quranLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.sizeToFit()
        label.textColor = .KMTextColor
        label.font = UIFont(name: "KFGQPCHAFSUthmanicScript-Regula", size: 24)
        return label
    }()
    
    
    func setupSubViews() {
        contentView.addSubview(scrollView)
        scrollView.addSubview(container)
        container.addSubview(quranLabel)
    }
    
    private func setupQuranLabelConstraints() {
        quranLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        quranLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 120).isActive = true
//        quranLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -24).isActive = true
        quranLabel.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 3.5/4).isActive = true
        quranLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true
    }
    
    func setupScrollViewConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    private func setupContainerViewContrstraints() {
        container.translatesAutoresizingMaskIntoConstraints = false
        container.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        container.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        container.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
//        container.heightAnchor.constraint(greaterThanOrEqualTo: heightAnchor, constant: 120).isActive = true
        container.heightAnchor.constraint(equalTo: scrollView.heightAnchor, constant: 200).isActive = true
        
    }
    
    private func setupAppearacne() {
//        scrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
        setupScrollViewConstraints()
        setupContainerViewContrstraints()
        setupQuranLabelConstraints()
        setupAppearacne()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
