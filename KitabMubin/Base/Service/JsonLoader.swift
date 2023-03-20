//
//  JsonLoader.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 21/10/2022.
//

import Foundation

class JsonLoader {
    static let shared = JsonLoader()
    
    private init() { }
    
    func loadJsonDataFromFile(_ path: String, completion: (Data?) -> Void) {
        if let fileUrl = Bundle.main.url(forResource: path, withExtension: "json") {
            do {
                let data = try Data(contentsOf: fileUrl, options: [])
                completion(data as Data)
            } catch (let error) {
                print(error.localizedDescription)
                completion(nil)
            }
        } else {
            print("error in file path")
        }
    }
}
