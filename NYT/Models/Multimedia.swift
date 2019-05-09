//
//  Multimedia.swift
//  NYT
//
//  Created by Steven Curtis on 29/04/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation

struct Multimedia: Codable {
    var height: Int
    var url: String?
    var width: Int
    
    private enum CodingKeys: String, CodingKey {
        case height = "height"
        case url = "url"
        case width = "width"
    }
}

extension Multimedia: Equatable {
    public static func == (lhs: Multimedia, rhs: Multimedia) -> Bool {
        return lhs.height == rhs.height
            && lhs.url == rhs.url
            && lhs.width == rhs.width
    }
}
