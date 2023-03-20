//
//  NetworkError.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 24/10/2022.
//

import Foundation

enum NetworkError: Error {
    case error(Error)
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .error:
            return "Internet Connection Error"
        }
    }
}

