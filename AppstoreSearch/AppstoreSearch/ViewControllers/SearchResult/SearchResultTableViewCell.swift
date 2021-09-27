//
//  SearchResultTableViewCell.swift
//  AppstoreSearch
//
//  Created by 박균호 on 2021/09/24.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var star: UILabel!
    @IBOutlet weak var previewImage1: UIImageView!
    @IBOutlet weak var previewImage2: UIImageView!
    @IBOutlet weak var previewImage3: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        icon.layer.cornerRadius = 10
        previewImage1.layer.cornerRadius = 10
        previewImage2.layer.cornerRadius = 10
        previewImage3.layer.cornerRadius = 10
    }
    
    override func prepareForReuse() {
        self.icon.image = nil
        self.previewImage1.image = nil
        self.previewImage2.image = nil
        self.previewImage3.image = nil
    }
    
    func configure(data: AppInfo) {
        ImageLoader.loadImage(url: data.artworkUrl100!) { [weak self] image in
            self?.icon.image = image
        }
        
        title.text = data.trackName
        subTitle.text = data.gereName
        star.text = setRating(data.averageUserRating ?? 0)
        
        guard let screenshotUrls = data.screenshotUrls else { return }
        let size = screenshotUrls.count
        
        if size >= 3 {
            ImageLoader.loadImage(url: screenshotUrls[0]) { [weak self] image in
                self?.previewImage1.image = image
            }
            ImageLoader.loadImage(url: screenshotUrls[1]) { [weak self] image in
                self?.previewImage2.image = image
            }
            ImageLoader.loadImage(url: screenshotUrls[2]) { [weak self] image in
                self?.previewImage3.image = image
            }
            
        } else if size == 2 {
            ImageLoader.loadImage(url: screenshotUrls[0]) { [weak self] image in
                self?.previewImage1.image = image
            }
            ImageLoader.loadImage(url: screenshotUrls[1]) { [weak self] image in
                self?.previewImage2.image = image
            }
            previewImage3.isHidden = true
        } else {
            ImageLoader.loadImage(url: screenshotUrls[0]) { [weak self] image in
                self?.previewImage1.image = image
            }
            previewImage2.isHidden = true
            previewImage3.isHidden = true
        }
    }
    
    func setRating(_ rating: Double) -> String {
        let rating = String(format: "%.f", rating)
        switch rating {
        case "1":
            return "★☆☆☆☆"
        case "2":
            return "★★☆☆☆"
        case "3":
            return "★★★☆☆"
        case "4":
            return "★★★★☆"
        case "5":
            return "★★★★★"
        default:
            return "☆☆☆☆☆"
        }
    }
}

