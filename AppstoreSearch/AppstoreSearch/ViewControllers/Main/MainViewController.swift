//
//  MainViewController.swift
//  AppstoreSearch
//
//  Created by 박균호 on 2021/09/23.
//

import UIKit

class MainViewController: UITableViewController {

    private var keywordListViewController: KeywordListViewController!
    private var searchResultListViewController: SearchResultListViewController!
    var searchController: UISearchController!
    let mainViewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keywordListInit()
        searchControllerInit()
        navigationInit()
        
        mainViewModel.fetchKeywords()
        mainViewModel.reloadTableViewClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    func keywordListInit() {
        let keywordListStoryboard = UIStoryboard(name: "KeywordList", bundle: nil)
        keywordListViewController = keywordListStoryboard.instantiateViewController(withIdentifier: "KeywordListViewController") as? KeywordListViewController
        keywordListViewController.tableView.delegate = self
    }
    
    func searchControllerInit() {
        searchController = UISearchController(searchResultsController: keywordListViewController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
    }
    
    func navigationInit() {
        title = "검색"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    func moveToSearchResultViewController(_ term: String) {
        let searchResultStoryboard = UIStoryboard(name: "SearchResultList", bundle: nil)
        searchResultListViewController = searchResultStoryboard.instantiateViewController(withIdentifier: "SearchResultListViewController") as? SearchResultListViewController
        
        searchResultListViewController.term = term
        
        self.addChild(searchResultListViewController)
        self.view.frame = searchResultListViewController.view.frame
        self.view.addSubview(searchResultListViewController.view)
        searchResultListViewController.didMove(toParent: self)
        keywordListViewController.dismiss(animated: true, completion: nil)
        searchController.searchBar.showsCancelButton = true
    }
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        
        let filteredKeywords = mainViewModel.filteredKeywords(keyword: text)
        
        if let keywordListViewController = searchController.searchResultsController as? KeywordListViewController {
            keywordListViewController.filteredKeywords = filteredKeywords
            keywordListViewController.tableView.reloadData()
        }
    }
}

extension MainViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            if let searchResultListViewController = searchResultListViewController {
                searchResultListViewController.removeFromParent()
                searchResultListViewController.view.removeFromSuperview()
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let keyword = searchBar.text {
            mainViewModel.setKeyword(keyword)
            moveToSearchResultViewController(keyword)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if let searchResultListViewController = searchResultListViewController {
            searchResultListViewController.willMove(toParent: self)
            searchResultListViewController.removeFromParent()
            searchResultListViewController.view.removeFromSuperview()
        }
        searchController.searchBar.endEditing(true)
        mainViewModel.fetchKeywords()
    }
    
}

extension MainViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainViewModel.countOfKeywords()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell") as? MainTableViewCell else {
            return UITableViewCell()
        }
        
        let keyword = mainViewModel.keyword(at: indexPath.row)
        cell.searchedText.text = keyword
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var keyword = ""
        
        if tableView == self.tableView {
            keyword = mainViewModel.keyword(at: indexPath.row)
        } else {
            keyword = keywordListViewController.filteredKeywords[indexPath.row]
        }
        
        searchController.searchBar.text = keyword
        moveToSearchResultViewController(keyword)
    }
}
