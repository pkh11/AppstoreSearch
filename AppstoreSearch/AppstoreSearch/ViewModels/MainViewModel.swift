//
//  MainViewModel.swift
//  AppstoreSearch
//
//  Created by 박균호 on 2021/09/24.
//

import Foundation

class MainViewModel {
    
    var appstoreSearchRepository = AppstoreSearchRepository()
    
    let userDefaults = UserDefaults.standard
    var reloadTableViewClosure: (()->())?
    
    private var recentKeywords: [String] = [] {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    func test() {
        appstoreSearchRepository.list()
    }
    
    func countOfKeywords() -> Int {
        return recentKeywords.count
    }
    
    func filteredKeywords(keyword: String) -> [String] {
        return recentKeywords.filter { $0.hasPrefix(keyword) }
    }
    
    func keyword(at index: Int) -> String {
        return recentKeywords[index]
    }
    
    func setKeyword(_ keyword: String) {
        if var savedKeywords = userDefaults.object(forKey: "keywords") as? [String] {
            savedKeywords.insert(keyword, at: 0)
            userDefaults.set(savedKeywords, forKey: "keywords")
        } else {
            userDefaults.set([keyword], forKey: "keywords")
        }
    }
    
    func fetchKeywords() {
        if let savedKeywords = userDefaults.object(forKey: "keywords") as? [String] {
            recentKeywords = savedKeywords
        }
    }
    
    func fetchResults() {
        
    }
}
