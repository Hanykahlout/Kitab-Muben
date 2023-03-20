//
//  UIViewController+Extensions.swift
//  BunYankm
//
//  Created by hady on 02/06/2022.
//

import UIKit
import SwiftMessages

extension UIViewController {

    //MARK: Alerts
    func showAlertWarning(title: String = "", body: String = "") {
        setupAlert(theme: .warning, title: title, body: body)
    }

    func showAlertError(title: String = "", body: String = "") {
        setupAlert(theme: .error, title: title, body: body)
    }

    func showAlertSuccess(title: String = "", body: String = "") {
        setupAlert(theme: .success, title: title, body: body)
    }

    func setupAlert(theme: Theme, title: String = "", body: String = "") {

        let msgView = MessageView.viewFromNib(layout: .messageView)
        msgView.configureContent(title: title, body: body)
        switch theme {
        case .success:
            msgView.configureTheme(backgroundColor: .KMGreanBackGround, foregroundColor: .white, iconImage: nil, iconText: nil)
        default:
            msgView.configureTheme(theme)
        }
        msgView.button?.isHidden = true
        msgView.configureDropShadow()
        msgView.titleLabel?.textAlignment = .center
        msgView.bodyLabel?.textAlignment = .center

        let size: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 25 : 17
        msgView.titleLabel?.font = UIFont(name: "Tajawal-Regular", size: size)
        msgView.bodyLabel?.font = UIFont(name: "Tajawal-Regular", size: size)

        msgView.titleLabel?.adjustsFontSizeToFitWidth = true
        msgView.bodyLabel?.adjustsFontSizeToFitWidth = true

        var config = SwiftMessages.defaultConfig

        config.presentationStyle = .top
        config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        config.duration = SwiftMessages.Duration.seconds(seconds: 3)

        SwiftMessages.show(config: config, view: msgView)
    }
    
    func addNavigationBarTitle(navigationTitle: String) {
        let lblNavigationTile = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 30))
        lblNavigationTile.textAlignment = .center
        //lblNavigationTile.backgroundColor = .clear
        lblNavigationTile.textColor = .white
        lblNavigationTile.font = .init(name: "Tajawal-Bold", size: 16)
        lblNavigationTile.text = navigationTitle
        lblNavigationTile.frame = CGRect(x: 0, y: 0, width: 120, height: 30)
        
        
        let barImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 82, height: 30))
        //barImage.image = UIImage(named: "icon_nav_bar.png")
        self.navigationItem.titleView = lblNavigationTile
    }
}

extension UIViewController {
//    public func showError(title: String? = "", message: String? = "") {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "حسنا", style: .default))
//        self.present(alert, animated: true)
//    }
}
