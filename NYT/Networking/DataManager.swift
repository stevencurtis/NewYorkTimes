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
    func fetchArticles(withAPI api: API, refresh: Bool, completion: @escaping (Result<(content: [DisplayContent], metadata: DisplayContentMetaData), Error>) -> Void)
}

class DataManager {
    static let shared: DataManager = DataManager()
    private var articles = [Article]()
    var currentContentPageIndex : UInt = pageIndex // Default page index
    var currentSearchPageIndex : UInt = pageIndex
    var fetching = false
    var HTTPManagerClass: HTTPManagerProtocol
    
    init() {
        HTTPManagerClass = HTTPManager()
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
                DispatchQueue.main.async { completion(.success(data))
                }
            }
        }
    }
    
    func fetchArticles(withAPI api: API, refresh: Bool, completion: @escaping (Result<(content: [DisplayContent], metadata: DisplayContentMetaData), Error>) -> Void) {
        let url : URL?
        if fetching {return}
        fetching = true
        switch api {
        case .getContents :
            if !refresh {
                currentContentPageIndex += 1
            }
            currentSearchPageIndex = 0
            url = API.getContents(pageIndex: currentContentPageIndex, pageSize: pageSize).url
        case .searchArticles(let query, _):
            url = API.searchArticles(query: query, pageIndex: currentSearchPageIndex).url
            if !refresh {
                currentSearchPageIndex += 1
            }
            currentContentPageIndex = 0
        }
        guard url != nil else {return}
        
        HTTPManagerClass.returnShared().get(url: url!) { result in
            
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
                    self.fetching = false
                    
                    DispatchQueue.main.async {
                        completion(.success((displayContent,meta)))
                    }
                    
                } catch {
                    do {
                        let decoder = JSONDecoder()
                        let searchContent = try decoder.decode(SearchResponse.self, from: data)
                        let displayContent = searchContent.response?.docs?.map{ DisplayContent(title: $0.headline?.main, abstract: $0.snippet, thumbnailImageString: nil, date: $0.pub_date, image: nil) }
                        
                        let meta = DisplayContentMetaData(hits: searchContent.response?.meta?.hits ?? 0, page: 0)
                        self.fetching = false

                        DispatchQueue.main.async {
                            if let displayContent = displayContent {
                                completion(.success((displayContent,meta)))
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

extension DataManager : DataManagerProtocol {}
