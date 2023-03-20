//
//  QuranPageModel.swift
//  KitabMubin
//
//  Created by Hany Alkahlout on 22/01/2023.
//

import Foundation


class QuranPageModel{
    var sure = [Sura]()
    var number = 0
    var jozz = 0
}


class Sura{
    var ayat = [Aya]() {
        didSet{
            hasBasmala = ayat.first?.number == 1
        }
    }
    var name = ""
    var hasBasmala = false
    
    func genrateSuraText()->String{
        var text = ""
        for aya in ayat{
            text += "\(aya.text) "
        }
        return text
    }
}

class Aya{
    var text = ""
    var number = 0
    
    init(text: String = "", number: Int = 0) {
        self.text = text
        self.number = number
    }
}

