//
//  SearchResult.swift
//  NYT
//
//  Created by Steven Curtis on 01/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation

public struct SearchResult : Codable {
    var slug_name: String?
//    var multimedia: [Multimedia]?

    private enum ContentResponse: String, CodingKey {
        case slug_name = "slug_name"
//        case multimedia = "multimedia"

    }
    
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        slug_name = try container.decode(String.self, forKey: .slug_name)
//
////        if let value = try? container.decode( [Multimedia].self , forKey: .multimedia) {
////            multimedia = value
////        }
//
//    }
    
}
