//
//  ScrollView+Extensions.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 24/11/2022.
//

import Foundation
import UIKit

extension UIScrollView {
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
   }
}
