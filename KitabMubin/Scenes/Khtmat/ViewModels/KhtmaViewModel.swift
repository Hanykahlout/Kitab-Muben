//
//  KhtmaViewModel.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 25/11/2022.
//

import Foundation
import RealmSwift

class KhtmaViewModel: Object {
    @Persisted var name: String?
    @Persisted var completed: Bool?
    @Persisted var date: Date?
    @Persisted var duration: Int?
    @Persisted var notificaiton_id: String?
}
