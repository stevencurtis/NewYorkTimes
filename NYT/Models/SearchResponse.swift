//
//  SearchResponse.swift
//  NYT
//
//  Created by Steven Curtis on 01/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation

public struct SearchResponse : Codable {
    var copyright: String?
    var status: String?
    var response: SearchDoc?
    
    private enum ContentResponse: String, CodingKey {
        case copyright = "copyright"
        case status = "status"
        case results = "response"
    }
}
