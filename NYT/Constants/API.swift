//
//  API.swift
//  NYT
//
//  Created by Steven Curtis on 05/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation

public enum API {
    case getContents(pageIndex: UInt? , pageSize: UInt? )
    case searchArticles(query: String , pageIndex: UInt? )
    
    func pageQuery() -> [URLQueryItem] {
        switch self {
        case .getContents(let idx, let sze) : return [URLQueryItem(name: "limit", value: "\(sze ?? pageSize)"), URLQueryItem(name: "offset", value: "\(idx ?? pageIndex * (sze ?? pageSize) )")]
        case .searchArticles(let query, let idx) : return [URLQueryItem(name: "q", value: query), URLQueryItem(name: "page", value: "\(idx ?? pageIndex)")]
        }
    }
    
    var url: URL? {
        var component = URLComponents()
        component.scheme = "https"
        component.host = "api.nytimes.com"
        component.path = path
        component.queryItems = pageQuery() + [URLQueryItem(name: "api-key", value: APIKeys.APIKey)]
        return component.url
    }
}


extension API {
    fileprivate var path: String {
        switch self {
        case .getContents:
            return "/svc/news/v3/content/all/all.json"
        case .searchArticles:
            return "/svc/search/v2/articlesearch.json"
        }
    }
    
    fileprivate var queryItems: [URLQueryItem] {
        switch self {
        case .getContents(let idx, let sze):
            return [URLQueryItem(name: "limit", value: "\(pageSize)"), URLQueryItem(name: "offset", value: "\( (idx ?? pageIndex) * (sze ?? pageSize))")]
        case .searchArticles(let query, let idx):
            return [URLQueryItem(name: "q", value: query), URLQueryItem(name: "page", value: "\(idx ?? pageIndex)")]
        }
    }
}
