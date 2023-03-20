//
//  UIApplication+Extensions.swift
//  BunYankm
//
//  Created by hady on 26/04/2022.
//

import UIKit

extension UIApplication {
    
    /// metod to return current top ViewController
    /// - Parameter controller: ViewController optional description
    /// - Returns: ViewController description
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        
        return controller
    }
}
