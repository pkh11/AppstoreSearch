//
//  DetailViewCell.swift
//  AppstoreSearch
//
//  Created by 박균호 on 2021/09/25.
//

import UIKit

class AppIconCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageView.layer.cornerRadius = 10
    }
    
    func configure(data: AppInfo) {
        ImageLoader.loadImage(url: data.artworkUrl100!) { [weak self] image in
            self?.iconImageView.image = image
        }
        title.text = data.trackName
        subTitle.text = data.sellerName
    }
}

class ComponentCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource  {
    @IBOutlet weak var collectionView: UICollectionView!
    
    struct Component {
        var title: String?
        var subTitle: String?
        var detail: String?
    }
    
    var components: [Component] = []
    var appInfo: AppInfo? = AppInfo()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func configure(data: AppInfo) {
        appInfo = data
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComponentCollecionViewCell", for: indexPath) as? ComponentCollectionViewCell else { return UICollectionViewCell() }
        
        cell.componentTitle.text = "title"
        cell.componentSubTitle.text = "4+"
        cell.componentDetail.text = "세"
        
        return cell
    }
}

class ComponentCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var componentTitle: UILabel!
    @IBOutlet weak var componentSubTitle: UILabel!
    @IBOutlet weak var componentDetail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class PreviewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var screenShots = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func configure(data: AppInfo) {
        guard let screenshotUrls = data.screenshotUrls else { return }
        screenShots = screenshotUrls
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenShots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PreviewCollectionViewCell", for: indexPath) as? PreviewCollectionViewCell else { return UICollectionViewCell() }
        
        ImageLoader.loadImage(url: screenShots[indexPath.row]) { image in
            cell.imageView.image = image
        }
        
        return cell
    }
}

class PreviewCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 10
    }
}
