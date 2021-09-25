//
//  AppstoreSearchRepository.swift
//  AppstoreSearch
//
//  Created by 박균호 on 2021/09/24.
//

import Foundation

class AppstoreSearchRepository {
    
    private let httpClient = HttpClient(baseURL: "https://itunes.apple.com")
    
    func fetchDatas(_ term: String, completion: @escaping ([AppInfo]) -> Void) {
        httpClient.getJson(path: "/search",
                           params: ["term" : term, "entity" : "software", "country" : "KR"]) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                guard let response = try? decoder.decode(ResponseData.self, from: data) else { return }
                if let results = response.results {
                    completion(results)
                }
            case .failure(_):
                print("error")
            }
        }
    }
}

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

struct AppInfo: Codable {
    var screenshotUrls: [String]?
    var ipadScreenshotUrls: [String]?
    var appletvScreenshotUrls: [String]?
    var artworkUrl60: String?
    var artworkUrl512: String?
    var artworkUrl100: String?
    var artistViewUrl: String?
    var features: [String]?
    var kind: String?
    var minimumOsVersion: String?
    var releaseDate: String?
    var trackId: Int?
    var trackName: String?
    var formattedPrice: String?
    var primaryGenreId: Int?
    var isVppDeviceBasedLicensingEnabled: Bool?
    var sellerName: String?
    var primaryGenreName: String?
    var currentVersionReleaseDate: String?
    var genreIds: [String]?
    var releaseNotes: String?
    var trackCensoredName: String?
    var languageCodesISO2A: [String]?
    var fileSizeBytes: String?
    var sellerUrl: String?
    var contentAdvisoryRating: String?
    var averageUserRatingForCurrentVersion: Double?
    var userRatingCountForCurrentVersion: Double?
    var averageUserRating: Double?
    var trackViewUrl: String?
    var trackContentRating: String?
    var description: String?
    var currency: String?
    var genres: [String]?
    var price: Double?
    var artistId: Int?
    var artistName: String?
    var bundleId: String?
    var version: String?
    var wrapperType: String?
    var userRatingCount: Int?
    
    var gereName: String {
        return primaryGenreNameToConvert(primaryGenreName!)
    }
}

func primaryGenreNameToConvert(_ genre: String) -> String {
    
    switch genre {
    case "Finance":
        return "금융"
    case "Lifestyle" :
        return "라이프스타일"
    case "Business" :
        return "비지니스"
    case "Education" :
        return "교육"
    case "Games" :
        return "게임"
    case "Music" :
        return "음악"
    case "Book" :
        return "도서"
    case "Productivity" :
        return "생산성"
    case "Social Networking" :
        return "소셜 네트워킹"
    case "Shopping" :
        return "쇼핑"
    default:
        return "앱"
    }
}
