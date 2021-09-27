//
//  MainViewModel.swift
//  AppstoreSearch
//
//  Created by 박균호 on 2021/09/24.
//

import Foundation

final class MainViewModel {
    
    private var appstoreSearchRepository = AppstoreSearchRepository()
    var reloadTableViewClosure: (()->())?
    
    private var recentKeywords: [String] = [] {
        didSet {
            self.reloadTableViewClosure?()
        }
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
        appstoreSearchRepository.setKeyword(keyword)
    }
    
    func fetchKeywords() {
        recentKeywords = appstoreSearchRepository.fetchKeywords()
    }
}
