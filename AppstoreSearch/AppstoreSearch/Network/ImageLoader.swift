//
//  ImageLoader.swift
//  AppstoreSearch
//
//  Created by 박균호 on 2021/09/25.
//

import UIKit

class CacheManager {
    static let sharedInstance = NSCache<NSString, UIImage>()
    private init() { }
}

class ImageLoader {
    static func loadImage(url: String, completed: @escaping (UIImage?) -> Void) {
        
        let cacheKey = NSString(string: url)
        
        if let cachedImage = CacheManager.sharedInstance.object(forKey: cacheKey) {
            completed(cachedImage)
        }
        
        DispatchQueue.global(qos: .background).async {
            if let imageUrl = URL(string: url) {
                URLSession.shared.dataTask(with: imageUrl) { (data, res, err) in
                    if let _ = err {
                        DispatchQueue.main.async {
                            completed(UIImage())
                        }
                    }
                    
                    DispatchQueue.main.async {
                        if let data = data,
                            let image = UIImage(data: data) {
                            CacheManager.sharedInstance.setObject(image, forKey: cacheKey)
                            completed(image)
                        }
                    }
                }.resume()
            }
        }
    }
}
