//
//  Article.swift
//  NYT
//
//  Created by Steven Curtis on 29/04/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation


// do the date here

public struct Article : Codable {
    var abstract: String?
    var thumbnail_standard: String?
    var multimedia: [Multimedia]?
    var published_date: Date? { return Article.dateOnlyFormatter.date(from: published_date_string ?? "2019-04-25T15:00:10+0000") }
    var published_date_string: String?
    var title: String?
    
    private enum CodingKeys: String, CodingKey {
        case abstract = "abstract"
        case multimedia = "multimedia"
        case published_date_string = "published_date"
        case thumbnail_standard = "thumbnail_standard"
        case title = "title"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let abstractVal = try? container.decode( String.self , forKey: .abstract) {
            abstract = abstractVal
        }
        
        if let publishedVal = try? container.decode(String.self, forKey: .published_date_string) {
            published_date_string = publishedVal
        }
        
        if let thumbnailVal = try? container.decode(String.self, forKey: .thumbnail_standard) {
            thumbnail_standard = thumbnailVal
        }
        
        if let titleVal = try? container.decode(String.self, forKey: .title) {
            title = titleVal
        }
        
        if let value = try? container.decode( [Multimedia].self , forKey: .multimedia) {
            multimedia = value
        }
    }
    
    static let dateOnlyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
        return formatter
    }()
}
