//
//  FawasilTableHeaderView.swift
//  KitabMubin
//
//  Created by MoamenHalanMac on 06/08/2022.
//

import UIKit

class FawasilTableHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Outlet's
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    // MARK: - Properties
    override func awakeFromNib() {
        super.awakeFromNib()
        setupAppearance()
    }
    
    // MARK: - Methods
    private func setupAppearance() {
        containerView.addCornerRadius(10)
        DispatchQueue.main.async { [weak self] in
            self?.setupSegment()
        }
    }
    
    func setupSegment() {
        segmentedControl.setTitle("الآيات", forSegmentAt: 0)
        segmentedControl.setTitle("الصفحات", forSegmentAt: 1)
        segmentedControl.addCornerRadius(12)
        segmentedControl.highlightSelectedSegment()
        segmentedControl.addTarget(self, action: #selector(SegmentedControlDidChange(_:)), for: .valueChanged)
    }
    
    //MARK: - IBActions
    @IBAction func SegmentedControlDidChange(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            NotificationsCenterHelper.post(name: Notification.Name("Open0"))
        case 1:
            NotificationsCenterHelper.post(name: Notification.Name("Open1"))
        default:
            break
        }
    }
}
