//
//  ConstantsAPI.swift
//  NYT
//
//  Created by Steven Curtis on 29/04/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation

let UserDefaultsKey = "SavedStringArray"

var savedSearches = 10

let pageSize : UInt = 10
let pageIndex : UInt = 0

public class APIKeys {
    // Insert API Key here
    static let APIKey = "tN3lr7Uvgd2CSnTAGlgpNkrupQWpEESn" 
}

func path(api: API) -> String {
    switch api {
    case .getContents:
        return "/svc/news/v3/content/all/all.json"
    default:
        return "/svc/search/v2/articlesearch.json"
    }
    
}



