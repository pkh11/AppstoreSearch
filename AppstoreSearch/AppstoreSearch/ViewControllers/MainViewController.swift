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
        
        //
        mainViewModel.test()
        //
        
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
        title = "Search"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func moveToSearchResultViewController() {
        let searchResultStoryboard = UIStoryboard(name: "SearchResultList", bundle: nil)
        searchResultListViewController = searchResultStoryboard.instantiateViewController(withIdentifier: "SearchResultListViewController") as? SearchResultListViewController
        
        keywordListViewController.addChild(searchResultListViewController)
        keywordListViewController.view.frame = searchResultListViewController.view.frame
        keywordListViewController.view.addSubview(searchResultListViewController.view)
        searchResultListViewController.didMove(toParent: keywordListViewController)
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
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let keyword = searchBar.text {
            mainViewModel.setKeyword(keyword)
        }
        moveToSearchResultViewController()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchResultListViewController.willMove(toParent: nil)
        searchResultListViewController.removeFromParent()
        searchResultListViewController.view.removeFromSuperview()
        
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
        if tableView == self.tableView {
            let keyword = mainViewModel.keyword(at: indexPath.row)
            searchController.searchBar.text = keyword
        } else {
            let filteredKeyword = keywordListViewController.filteredKeywords[indexPath.row]
            searchController.searchBar.text = filteredKeyword
        }
        moveToSearchResultViewController()
    }
}
