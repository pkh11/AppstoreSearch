//
//  ResponseData.swift
//  AppstoreSearch
//
//  Created by 박균호 on 2021/09/27.
//

import Foundation

struct ResponseData: Codable {
    var resultCount: Int?
    var results: [AppInfo]?
    
    enum CodingKeys: CodingKey {
        case resultCount
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        resultCount = try container.decode(Int.self, forKey: .resultCount)
        results = try container.decode([AppInfo].self, forKey: .results)
    }
}
