//
//  MainTabBarViewController.swift
//  KitabMubin
//
//  Created by Hany Alkahlout on 05/02/2023.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

   
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font:UIFont(name: "Tajawal-Bold", size: 14)!], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font:UIFont(name: "Tajawal-Bold", size: 14)!], for: .selected)
        
        
    }


}
