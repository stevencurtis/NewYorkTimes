//
//  MockDataManager.swift
//  NYTTests
//
//  Created by Steven Curtis on 04/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation
import UIKit
@testable import NYT

protocol DataManagerMockProtocol{
    func setArticles(displayContent : [DisplayContent])
    func setForFailure(willFail: Bool)
}

typealias DMMock = DataManagerProtocol & DataManagerMockProtocol

class DataManagerMock: DMMock {
    
    var articlesDidChange: ((([DisplayContent]?, DisplayContentMetaData?)) -> Void)?

    
    var fetching = false
    var previousAPICall : API?
    
    var metaData : DisplayContentMetaData?

    var articles : [DisplayContent]? {
        didSet {
            articlesDidChange?((articles, metaData))
        }
    }
    
    var willFail: Bool = false
    
    func setForFailure(willFail: Bool) {
        self.willFail = willFail
    }
    
    func setArticles(displayContent: [DisplayContent]) {
        dc = displayContent
    }
    
    var dc = [DisplayContent(title: "testTitle", abstract: "testAbstract", thumbnailImageString: "testThumbnail", date: "testDate", image: "testImg")]
    
    func fetchImageData(withURLString urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        if willFail {
            let er = NSError(domain: "test domain", code: -1009, userInfo: nil)
            completion(.failure(er))
            return
        }
        
        let localImage = UIImage(named: "test.png", in: Bundle(for: type(of: self)), compatibleWith: nil)
        let data = localImage!.pngData()
        completion(.success(data!))
    }
    
    func fetchArticles(withAPI api: API?, refresh: Bool, completion: @escaping (Result<(content: [DisplayContent], metadata: DisplayContentMetaData, refresh: Bool), Error>) -> Void) {
        if fetching {return}
        
        if willFail {
            let er = NSError(domain: "test domain", code: -1009, userInfo: nil)
            completion(.failure(er))
            return
        }
        
        let md = DisplayContentMetaData(hits: dc.count, page: 1)
        metaData = md
        articles = dc
        
        completion(.success((dc,md, refresh)))
    }
    
    
    func fetchMore(completion: @escaping (Result<(content: [DisplayContent], metadata: DisplayContentMetaData, refresh: Bool), Error>) -> Void) {
        
        if willFail {
            let er = NSError(domain: "test domain", code: -1009, userInfo: nil)
            completion(.failure(er))
            return
        }

        fetchArticles(withAPI: previousAPICall, refresh: false, completion: completion)
    }
    
    func clearDM() {
        fetching = false
    }
    

    
    
}



