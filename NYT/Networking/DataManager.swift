//
//  DataManager.swift
//  NYT
//
//  Created by Steven Curtis on 29/04/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation
import UIKit

public protocol DataManagerProtocol {
    func fetchImageData(withURLString urlString: String, completion: @escaping (Result<Data, Error>) -> Void)
    func fetchArticles(withAPI api: API?, refresh: Bool, completion: @escaping (Result<(content: [DisplayContent], metadata: DisplayContentMetaData, refresh: Bool), Error>) -> Void)
    var articlesDidChange: ((([DisplayContent]?, DisplayContentMetaData?)) -> Void)? { get set }
    func fetchMore(completion: @escaping (Result<(content: [DisplayContent], metadata: DisplayContentMetaData, refresh: Bool), Error>) -> Void)
    func clearDM()
}

class DataManager {
    
    var metaData : DisplayContentMetaData?
    var articles : [DisplayContent]? {
        didSet {
            articlesDidChange?((articles,metaData))
        }
    }
    
    var articlesDidChange: ((([DisplayContent]?, DisplayContentMetaData?)) -> Void)?

    static let shared = DataManager.init()
    
    var currentContentPageIndex : UInt = pageIndex // Default page index
    var currentSearchPageIndex : UInt = pageIndex // Default page index
    var fetching = false
    var HTTPManagerClass: HTTPManagerProtocol
    
    var previousAPICall : API?
    
    var cache: NSCache<AnyObject, AnyObject>?
    
    init() {
        HTTPManagerClass = HTTPManager(session: URLSession.shared)
    }
    
    init(httpManager: HTTPManagerProtocol){
        HTTPManagerClass = httpManager
    }
    
    func fetchImageData(withURLString urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        HTTPManagerClass.get(urlString: urlString) { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async { completion(.failure(error)) }
            case .success(let data):
                DispatchQueue.main.async { completion(.success(data)) }
            }
        }
    }
    
    func fetchMore(completion: @escaping (Result<(content: [DisplayContent], metadata: DisplayContentMetaData, refresh: Bool), Error>) -> Void) {
        guard let previousAPI = previousAPICall else {return}
        fetchArticles(withAPI: previousAPI, refresh: false, completion: completion)
    }
    
    func clearDM() {
        self.articles?.removeAll()
    }
    
    /// fetch articles from the API. If we are refreshing, we need to move to the next page. If we aren't, this is the first time we are accessing these pages we will visit the first page.
    func fetchArticles(withAPI api: API? = nil, refresh: Bool, completion: @escaping (Result<(content: [DisplayContent], metadata: DisplayContentMetaData, refresh: Bool), Error>) -> Void) {
        let url : URL?
        
        let currentAPI = api ?? (previousAPICall ?? API.getContents(pageIndex: pageIndex, pageSize: pageSize) )
        if fetching {return}
        fetching = true
        switch currentAPI {
        case .getContents :
            if refresh {
                currentContentPageIndex = 0
                
            } else {
                currentContentPageIndex += 1
            }
            currentSearchPageIndex = 0
            url = API.getContents(pageIndex: currentContentPageIndex, pageSize: pageSize).url
        case .searchArticles(let query, _):
            if refresh {
                currentSearchPageIndex = 0
            } else {
                currentSearchPageIndex += 1
            }
            currentContentPageIndex = 0
            url = API.searchArticles(query: query, pageIndex: currentSearchPageIndex).url
        }
        
        previousAPICall = currentAPI
        
        guard url != nil else {return}
        
        HTTPManagerClass.get(url: url!) { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async { completion(.failure(error))
                }
                
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let content = try decoder.decode(ContentResponse.self, from: data)
                    let displayContent = content.results.map{ DisplayContent(title: $0.title, abstract: $0.abstract, thumbnailImageString: $0.thumbnail_standard, date: $0.published_date?.dateString, image: $0.multimedia?.last?.url) }
                    
                    let meta = DisplayContentMetaData(hits: content.num_results ?? 0, page: 0)
                    
                    if refresh || self.articles == nil {
                        self.articles = displayContent
                    } else {
                        self.articles = (self.articles ?? [] ) + displayContent
                    }
                    
                    self.fetching = false
                    
                    DispatchQueue.main.async {
                        completion(.success((displayContent,meta,refresh)))
                    }
                } catch {
                    do {
                        let decoder = JSONDecoder()
                        let searchContent = try decoder.decode(SearchResponse.self, from: data)
                        let displayContent = searchContent.response?.docs?.map{ DisplayContent(title: $0.headline?.main, abstract: $0.snippet, thumbnailImageString: nil, date: $0.published_date?.dateString, image: nil) }
                        
                        if refresh || self.articles == nil {
                            self.articles = displayContent
                        } else {
                            self.articles = (self.articles ?? [] ) + (displayContent ?? [])
                        }
                        
                        let meta = DisplayContentMetaData(hits: searchContent.response?.meta?.hits ?? 0, page: 0)
                        self.fetching = false
                        
                        DispatchQueue.main.async {
                            if let displayContent = displayContent {
                                completion(.success((displayContent,meta,refresh)))
                            }
                        }
                    } catch {
                        print(String(data: data, encoding: .utf8) ?? "Unable to retrieve string representation")
                        self.fetching = false
                        DispatchQueue.main.async { completion(.failure(error)) }
                    }
                }
            }
        }
    }
}

extension DataManager : DataManagerProtocol {

    
}
