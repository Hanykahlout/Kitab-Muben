//
//  FawasilViewModel.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 28/11/2022.
//

import Foundation

class FawasilViewModel {
    var ayatViewModels: [BookmarkViewModel] = [BookmarkViewModel]()
    var pagesViewModels: [BookmarkViewModel] = [BookmarkViewModel]()
    private var tag: Int?
    private var test: Int?
    
    init(tag: Int) {
        self.tag = tag
        test = numberOfRowsInSection
        getFawasil()
    }
    
    var numberOfRowsInSection: Int {
        switch tag {
        case 0:
            print(ayatViewModels.count)
            return ayatViewModels.count
        case 1:
            return pagesViewModels.count
        default:
            return 0
        }
    }
    
    func dataSource(for indexPath: IndexPath) -> BookmarkViewModel? {
        switch tag {
        case 0:
            return ayatViewModels[indexPath.row]
        case 1:
            return pagesViewModels[indexPath.row]
        default:
            return nil
        }
    }
    
    func getFawasil(){
        pagesViewModels.removeAll()
        switch tag {
        case 0:
//            return ayatViewModels[indexPath.row]
            break
        case 1:
            if let pages = RealmManager.sharedInstance.fetchObjects(SavedPage.self){
                for page in pages{
                    pagesViewModels.append(.init(title: page.suraName ?? "----",subtitle: page.suraContent ?? "-----",pageNumber: page.pageNumber))
                }
            }
        default:
            break
        }
    }
        
    func removePage(at indexPath:IndexPath){
        RealmManager.sharedInstance.removeWhere(column: "pageNumber", value: pagesViewModels[indexPath.row].pageNumber ?? -1, for: SavedPage.self)
        pagesViewModels.remove(at: indexPath.row)
        
    }
    
}


    
