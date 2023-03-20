//
//  MoshfViewModel.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 25/10/2022.
//

import Foundation

class MoshfViewModel {
    
    private var dataSource: [QuranModel]?
    private var viewModels: [QuranViewModel] = [QuranViewModel]()
    private var quranPages: [QuranPageModel] = [QuranPageModel]()
    private var page: Int?
    
    // MARK: - Properties
    private var pageNumber: Int = 0
    private var jozNumber: Int = 0
    private var suraName: String = ""
    private var pageContents = [String]()
    private var hideBasmala: Bool = true
    private var isSaved: Bool = false
    
    init(dataSource: [QuranModel]?, page: Int) {
        self.dataSource = dataSource
        self.page = page
        setupViewModels()
    }
    
    private func setupViewModels() {
        
        var currentPage = dataSource?.first?.page ?? 0
        var page = QuranPageModel()
        var sura = Sura()
        dataSource?.forEach({ model in
            if model.page == currentPage {
                if sura.name == model.sura_name_ar ?? "" || sura.name == ""{
                    sura.name = model.sura_name_ar ?? ""
                    sura.ayat.append(.init(text: model.aya_text ?? "",number: model.aya_no ?? 0))
                    
                }else{
                    page.sure.append(sura)
                    sura = Sura()
                    sura.name = model.sura_name_ar ?? ""
                    sura.ayat.append(.init(text: model.aya_text ?? "",number: model.aya_no ?? 0))
                }
                
                guard let secondAyaIndex = model.id else {return}
                if secondAyaIndex < dataSource!.count {
                    if dataSource?[secondAyaIndex].page != currentPage{
                        if  model.page == currentPage{
                            page.sure.append(sura)
                            sura = Sura()
                            
                        }
                    }
                }else{
                    page.sure.append(sura)
                    sura = Sura()
                    page.number = currentPage
                    page.jozz = model.jozz ?? 0
                    quranPages.append(page)
                }
                
            }else{
                if currentPage  == 48{
                    sura.name = model.sura_name_ar ?? ""
                    sura.ayat.append(.init(text: model.aya_text ?? "",number: model.aya_no ?? 0))
                    page.sure.append(sura)
                    sura = Sura()
                }
                
                /// Add rest of page data
                page.number = currentPage
                page.jozz = model.jozz ?? 0
                
                /// Added page to quran pages
                quranPages.append(page)
                
                /// Clear object and Update page number for the next page
                currentPage = model.page ?? 0
                page = QuranPageModel()
                sura = Sura()
                
                /// Add current aya date to sura
                sura.name = model.sura_name_ar ?? ""
                sura.ayat.append(.init(text: model.aya_text ?? "",number: model.aya_no ?? 0))
            }
        })
        
    }
    
    func getQuran() -> [QuranPageModel]{
        return quranPages
    }
    
    func showData() -> QuranViewModel {
        return QuranViewModel(suraName: suraName, jozzNumber: jozNumber, pageNumber: pageNumber, suraContent: pageContents.joined(), hideBasmala: hideBasmala,isSaved:isSaved)
    }
    
    func unsavePage(page:Int){
        RealmManager.sharedInstance.removeWhere(column: "pageNumber", value: page , for: SavedPage.self)
    }
    
    func savePage(index:Int){
        let obj = quranPages[index]
        let savedPage = SavedPage()
        savedPage.suraName = obj.sure.first?.name ?? "----"
        savedPage.jozzNumber = obj.jozz
        savedPage.pageNumber = obj.number
        RealmManager.sharedInstance.saveObject(savedPage)
    }
    
}
