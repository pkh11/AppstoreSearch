//
//  DetailViewController.swift
//  AppstoreSearch
//
//  Created by 박균호 on 2021/09/25.
//

import UIKit

class DetailViewController: UITableViewController {

    var appInfo: AppInfo = AppInfo()
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension DetailViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AppIconCell") as? AppIconCell else { return UITableViewCell() }
            
            cell.configure(data: appInfo)
            
            return cell
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewFeatureCell") as? NewFeatureCell else { return UITableViewCell() }
            cell.configure(data: appInfo)
            return cell
        } else if indexPath.row == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PreviewCell") as? PreviewCell else { return UITableViewCell() }
            
            cell.configure(data: appInfo)
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell") as? DescriptionCell else { return UITableViewCell() }
            cell.configure(data: appInfo)

            return cell
        }
    }
}
