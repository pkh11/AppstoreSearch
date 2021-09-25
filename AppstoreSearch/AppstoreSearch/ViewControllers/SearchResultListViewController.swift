//
//  SearchResultViewController.swift
//  AppstoreSearch
//
//  Created by 박균호 on 2021/09/23.
//

import UIKit

class SearchResultListViewController: UITableViewController, UISearchBarDelegate {
    
    private var searchResultViewModel = SearchResultViewModel()
    var term: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchResultViewModel.fetchDatas(term)
        searchResultViewModel.reloadTableViewClosure = {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension SearchResultListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultViewModel.countOfList()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell") as? SearchResultTableViewCell else {
            return UITableViewCell()
        }
        
        let app = searchResultViewModel.app(at: indexPath.row)
        cell.configure(data: app)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "DetailView", bundle: nil)
        guard let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
        detailViewController.appInfo = searchResultViewModel.app(at: indexPath.row)
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
