//
//  NetworkManager.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 24/10/2022.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    func fetchData<T: Decodable>(model: T.Type, endpoint: Endpoint, method: APIHTTPMethod, parameters: [String: Any]? = nil, completion: @escaping (Result<T?, NetworkError>) -> Void) {
        guard let url = endpoint.url else { return }
        var urlRequst = URLRequest(url: url)
        urlRequst.httpMethod = method.rawValue
        
        switch method {
        case .post:
            urlRequst.httpBody = parameters?.percentEncoded()
        default: break
        }
        
        let task = URLSession.shared.dataTask(with: urlRequst) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(NetworkError.error(error!)))
                return
            }
            do {
                let results = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(results))
                }
            }
            catch {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.error(error)))
                }
            }
        }
        task.resume()
    }
}

