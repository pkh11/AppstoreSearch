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

class NewFeatureCell: UITableViewCell {
    @IBOutlet weak var version: UILabel!
    @IBOutlet weak var releaseNotes: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
 
    func configure(data: AppInfo) {
        guard let versionInfo = data.version,
                let releaseNote = data.releaseNotes else { return }
        version.text = "버전 \(versionInfo)"
        releaseNotes.text = releaseNote
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
    
    override func prepareForReuse() {
        self.imageView.image = nil
    }
}

class DescriptionCell: UITableViewCell {
    @IBOutlet weak var appDescription: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(data: AppInfo) {
        guard let description = data.description else { return }
        appDescription.text = description
    }
}
