//
//  HttpClient.swift
//  AppstoreSearch
//
//  Created by 박균호 on 2021/09/24.
//

import Foundation

class HttpClient {
    private let baseURL: String
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func getJson(path: String, params: [String: String], completion: @escaping (Result<Data, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            
            var urlComponents = URLComponents(string: self.baseURL + path)
            var quertItems = [URLQueryItem]()

            params.forEach{ key, value in
                let item = URLQueryItem(name: key, value: value)
                quertItems.append(item)
            }
            urlComponents?.queryItems = quertItems
            
            guard let url = urlComponents?.url else { return }
            
            let session = URLSession(configuration: .default)
            let dataTask = session.dataTask(with: url) { (data, response, error) in
                if let reponseData = response as? HTTPURLResponse {
                    if reponseData.statusCode == 200 {
                        completion(Result.success(data!))
                    } else {
                        print("Status Code is not 200")
                    }
                } else {
                    completion(Result.failure(error!))
                }
            }.resume()
        }
    }
    
    
}
