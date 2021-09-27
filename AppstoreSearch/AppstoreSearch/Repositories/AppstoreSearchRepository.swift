//
//  AppstoreSearchRepository.swift
//  AppstoreSearch
//
//  Created by 박균호 on 2021/09/24.
//

import Foundation

class AppstoreSearchRepository {
    
    private let httpClient = HttpClient(baseURL: "https://itunes.apple.com")
    private let userDefaults = UserDefaults.standard
    
    func fetchDatas(_ term: String, completion: @escaping ([AppInfo]) -> Void) {
        httpClient.getJson(path: "/search",
                           params: ["term" : term, "entity" : "software", "country" : "KR"]) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                guard let response = try? decoder.decode(ResponseData.self, from: data) else { return }
                
                if let results = response.results {
                    completion(results)
                }
            case .failure(let error):
                print("error")
            }
        }
    }
    
    func fetchKeywords() -> [String]{
        if let savedKeywords = userDefaults.object(forKey: "keywords") as? [String] {
            return savedKeywords
        }
        return []
    }
    
    func setKeyword(_ keyword: String) {
        if var savedKeywords = userDefaults.object(forKey: "keywords") as? [String] {
            savedKeywords.insert(keyword, at: 0)
            userDefaults.set(savedKeywords, forKey: "keywords")
        } else {
            userDefaults.set([keyword], forKey: "keywords")
        }
    }
}

