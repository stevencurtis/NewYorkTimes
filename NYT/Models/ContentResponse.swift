//
//  ContentResponse.swift
//  NYT
//
//  Created by Steven Curtis on 29/04/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation

public struct ContentResponse : Codable {
    var status: String?
    var copyright: String?
    var results: [Article]
    var num_results: Int?
    
    private enum ContentResponse: String, CodingKey {
        case status = "status"
        case copyright = "copyright"
        case results = "results"
        case num_results = "num_results"
    }
}

