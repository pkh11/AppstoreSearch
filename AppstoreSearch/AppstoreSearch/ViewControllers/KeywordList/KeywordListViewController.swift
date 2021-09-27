//
//  KeywordListViewController.swift
//  AppstoreSearch
//
//  Created by 박균호 on 2021/09/24.
//

import UIKit

class KeywordListViewController: UITableViewController {
    
    var filteredKeywords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension KeywordListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredKeywords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "KeywordTableViewCell") as? KeywordTableViewCell else {
            return UITableViewCell()
        }
        
        cell.keywordText.text = filteredKeywords[indexPath.row]
        
        return cell
    }
}
