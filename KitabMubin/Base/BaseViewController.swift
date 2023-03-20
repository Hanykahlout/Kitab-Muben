//
//  BaseViewController.swift
//  KitabMubin
//
//  Created by MoamenHalanMac on 26/07/2022.
//

import UIKit
import MBProgressHUD

class BaseViewController: UIViewController {
    
    // MARK: - Controller LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupSubViews()
        registerCells()
        assignDelegates()
        fetchNeededData()
        setupLocalization()
    }
    
    // MARK: - Status Bar Style
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: - Methods
    func setupAppearance() {
        view.backgroundColor = .KMWhiteBackGround
    }
    func setupSubViews() {}
    func registerCells() {}
    func assignDelegates() {}
    func fetchNeededData() {}
    func setupLocalization() {}
    func showMessage(message: String) {
        showAlertError(title: message)
    }
    
    func showLoadingIndicator() {
        MBProgressHUD.showAdded(to: view, animated: true)
    }
    
    func hideLoadingIndicator() {
        MBProgressHUD.hide(for: view, animated: true)
    }
}
