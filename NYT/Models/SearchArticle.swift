//
//  SearchArticle.swift
//  NYT
//
//  Created by Steven Curtis on 01/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation

public struct SearchArticle : Codable {
    var multimedia: [Multimedia]?
    var web_url : String?
    var pub_date: String?
    var snippet: String?
    var headline: SearchHeadline?
    
    var published_date: Date? { return SearchArticle.dateOnlyFormatter.date(from: pub_date ?? "2019-04-25T15:00:10+0000") }
    
    private enum CodingKeys: String, CodingKey {
        case multimedia = "multimedia"
        case web_url = "web_url"
        case pub_date = "pub_date"
        case snippet = "snippet"
        case headline = "headline"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        web_url = try container.decode(String.self, forKey: .web_url)
        if let pub = try? container.decode(String.self, forKey: .pub_date) {
            pub_date = pub
        } else {
            pub_date = nil
        }
        
        snippet = try container.decode(String.self, forKey: .snippet)
        headline = try container.decode(SearchHeadline.self, forKey: .headline)
        
        if let value = try? container.decode( [Multimedia].self , forKey: .multimedia) {
            multimedia = value
        } else {
            if let newVal = try? container.decode(Multimedia.self, forKey: .multimedia) {
                multimedia = [newVal]
            }
        }
    }
    
    static let dateOnlyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
        return formatter
    }()
}
