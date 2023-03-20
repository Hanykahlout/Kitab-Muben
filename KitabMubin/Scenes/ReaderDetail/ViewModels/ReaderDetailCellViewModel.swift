//
//  ReaderDetailCellViewModel.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 15/11/2022.
//

import Foundation

class ReaderDetailCellViewModel {
    var isDonwloaded: Bool
    var suraName: String?
    var audioURL: String?
    var isSelected = false
    var sliderValue:Float = 0.0
    var sliderMaxValue:Float = 0.0
    init(dataSource: ReaderDetailsData, isDonwloaded: Bool) {
        suraName = dataSource.sura_name
        audioURL = "http://api.kitabmuben.com/\(dataSource.audio_file ?? "")"
        self.isDonwloaded = isDonwloaded
    }
}



