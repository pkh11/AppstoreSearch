//
//  SearchResultViewController.swift
//  AppstoreSearch
//
//  Created by 박균호 on 2021/09/23.
//

import UIKit

class SearchResultListViewController: UITableViewController, UISearchBarDelegate {
    
    private var searchResultViewModel = SearchResultViewModel()
    let activity = UIActivityIndicatorView()
    var term: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicatorInit()
        
        searchResultViewModel.fetchDatas(term)
        searchResultViewModel.reloadTableViewClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.activity.stopAnimating()
                self?.tableView.reloadData()
            }
        }
    }
    
    func indicatorInit() {
        view.addSubview(activity)
        activity.tintColor = .red
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activity.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        activity.startAnimating()
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
        
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
