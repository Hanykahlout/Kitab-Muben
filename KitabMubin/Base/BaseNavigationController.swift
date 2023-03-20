//
//  BaseNavigationController.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 26/10/2022.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    convenience init(_ rootViewController: UIViewController) {
        self.init(rootViewController: rootViewController)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarStyle()
        setPresentationStyle(with: .fullScreen)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
    
    override public func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.visibleViewController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ",
                                                                                       style: .plain,
                                                                                       target: nil,
                                                                                       action: nil)
        super.pushViewController(viewController,
                                 animated: animated)
    }
    
    public func setPresentationStyle(with style: UIModalPresentationStyle) {
        self.modalPresentationStyle = style
    }
    
    private func setNavigationBarStyle() {
        let navigationBarAppearace = UINavigationBar.appearance()
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.KMTextColor, NSAttributedString.Key.font: UIFont(name: "Tajawal-Medium", size: 15) ?? UIFont()] as [NSAttributedString.Key : Any]
        let largeTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.KMTextColor, NSAttributedString.Key.font: UIFont(name: "Tajawal-Bold", size: 30) ?? UIFont()] as [NSAttributedString.Key : Any]
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            appearance.shadowImage = UIImage()
            appearance.shadowColor = .clear
            appearance.titleTextAttributes = textAttributes as [NSAttributedString.Key : Any]
            appearance.largeTitleTextAttributes = largeTextAttributes
            navigationBarAppearace.standardAppearance = appearance
            navigationBarAppearace.standardAppearance = appearance
        } else {
            navigationBarAppearace.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            navigationBarAppearace.shadowImage = UIImage()
        }
        navigationBarAppearace.titleTextAttributes = textAttributes
        navigationBarAppearace.largeTitleTextAttributes = largeTextAttributes
        navigationBarAppearace.barTintColor = UIColor.white
        navigationBarAppearace.tintColor = .KMGreanBackGround
    }
}
