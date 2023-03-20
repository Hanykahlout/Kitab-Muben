//
//  RealmExtensions.swift
//  KitabMubin
//
//  Created by Hany Alkahlout on 22/01/2023.
//

import Foundation
import RealmSwift

extension RealmCollection {
  func toArray<T>() ->[T]
  {
    return self.compactMap{$0 as? T}
  }
    
    
    
}
