//
//  MainViewController.swift
//  AppstoreSearch
//
//  Created by 박균호 on 2021/09/23.
//

import UIKit

class MainViewController: UITableViewController {

    private var searchResultListViewController: SearchResultListViewController!
    let searchController = UISearchController(searchResultsController: nil)
    let mainViewModel = MainViewModel()
    
    var searchResults: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureSearchController()
        
        mainViewModel.fetchKeywords()
        mainViewModel.reloadTableViewClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

extension MainViewController {
    func configureSearchController() {
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
    }
    
    func moveToSearchResultViewController(_ term: String) {
        let searchResultStoryboard = UIStoryboard(name: "SearchResultList", bundle: nil)
        searchResultListViewController = searchResultStoryboard.instantiateViewController(withIdentifier: "SearchResultListViewController") as? SearchResultListViewController
        
        searchResultListViewController.term = term
        searchController.isActive = true
        
        self.addChild(searchResultListViewController)
        self.view.frame = searchResultListViewController.view.frame
        self.view.addSubview(searchResultListViewController.view)
    }
    
    func isSearchBarEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !isSearchBarEmpty()
    }
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            return
        }
        
        if let searchResultListViewController = searchResultListViewController {
            searchResultListViewController.willMove(toParent: self)
            searchResultListViewController.removeFromParent()
            searchResultListViewController.view.removeFromSuperview()
        }
        
        searchResults = mainViewModel.filteredKeywords(keyword: text)
        tableView.reloadData()
    }
}

extension MainViewController: UISearchBarDelegate {
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
        
        searchResults = []
        mainViewModel.fetchKeywords()
    }
}

extension MainViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return searchResults.count
        } else {
            return mainViewModel.countOfKeywords()
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .systemBackground
        
        let headerText = UILabel()
        headerText.text = "새로운 발견"
        headerText.font = .systemFont(ofSize: 20)
        headerText.textAlignment = .left
        
        headerView.addSubview(headerText)
        
        headerText.translatesAutoresizingMaskIntoConstraints = false
        headerText.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 18).isActive = true
        headerText.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: 18).isActive = true
        headerText.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell") as? MainTableViewCell else {
            return UITableViewCell()
        }
        
        if isFiltering() {
            cell.searchedText.text = searchResults[indexPath.row]
            cell.searchIcon.isHidden = false
        } else {
            cell.searchedText.text = mainViewModel.keyword(at: indexPath.row)
            cell.searchedText.textColor = .black
            cell.searchIcon.isHidden = true
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var keyword = ""
        
        if isFiltering() {
            keyword = searchResults[indexPath.row]
        } else {
            keyword = mainViewModel.keyword(at: indexPath.row)
        }
        
        searchController.searchBar.text = keyword
        moveToSearchResultViewController(keyword)
    }
}
