//
//  KeywordViewModel.swift
//  AppstoreSearch
//
//  Created by 박균호 on 2021/09/25.
//

import Foundation

final class SearchResultViewModel {
    private var appstoreSearchRepository = AppstoreSearchRepository()
    private var appList: [AppInfo] = [] {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    var reloadTableViewClosure: (()->())?
    
    func fetchDatas(_ term: String) {
        appstoreSearchRepository.fetchDatas(term) { [weak self] appList in
            self?.appList = appList
        }
    }
    
    func app(at index: Int) -> AppInfo {
        return appList[index]
    }
    
    func countOfList() -> Int {
        return appList.count
    }
}
