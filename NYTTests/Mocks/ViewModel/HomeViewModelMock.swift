//
//  HomeViewModelMock.swift
//  NYTTests
//
//  Created by Steven Curtis on 08/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation
@testable import NYT

protocol HomeViewMockProtocol{
    func setForFailure(willFail: Bool)
    func setNumberMetaData(hits: Int, page: Int)
}

typealias HVMock = HomeViewModelProtocol & HomeViewMockProtocol

class HomeViewModelMock : HVMock {
    
    var willFail: Bool = false
    
    private var dataManagerClass: DataManagerProtocol

    
    init(dataManager: DataManagerProtocol, model: [DisplayContent]? = nil) {
        articles = model
        self.dataManagerClass = dataManager
        
        // if another class changes the dataManager, we want to listen to the changes too!
        dataManagerClass.articlesDidChange = { [weak self] result in
            guard let self = self else {return}
            self.articles = result.0
            self.metaData = result.1
        }
    }
    
    func setNumberMetaData(hits: Int, page: Int) {
        let meta = DisplayContentMetaData(hits: hits, page: 1)
        self.metaData = meta
    }
    
    var articles : [DisplayContent]? {
        didSet {
            articlesDidChange?((articles, metaData))
        }
    }
    
    var metaData : DisplayContentMetaData?
    var articlesDidChange: ((([DisplayContent]?, DisplayContentMetaData?)) -> Void)?
    
    func setForFailure(willFail: Bool) {
        self.willFail = willFail
    }
    
    func retrieveImage(imgURL: String, completion: @escaping (Result<Data, Error>) -> Void) {
        if willFail {
            let er = NSError(domain: "test domain", code: -1009, userInfo: nil)
            completion(.failure(er))
            return
        }
        
        func retrieveImage(imgURL: String, completion: @escaping (Result<Data, Error>) -> Void) {
            dataManagerClass.fetchImageData(withURLString: imgURL) {
                result in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async { completion(.failure(error)) }
                case .success(let data):
                    DispatchQueue.main.async { completion(.success(data)) }
                }
            }
    }
    }
    
    func fetchMore(completion: ((Result<(content: [DisplayContent], metadata: DisplayContentMetaData, refresh: Bool), Error>) -> Void)?) {
        if willFail {
            let er = NSError(domain: "test domain", code: -1009, userInfo: nil)
            if let completion = completion {
                completion(.failure(er))
            }
            return
        }
        
        dataManagerClass.fetchMore { result in
            switch result {
            case .failure: self.articles = nil; self.metaData = nil
            case .success: break
            }
            if let completion = completion {
                completion(result)
            }
        }
    }
    
    func fetchArticle(refresh: Bool?, completion: ((Result<(content: [DisplayContent], metadata: DisplayContentMetaData, refresh: Bool), Error>) -> Void)?) {
        if willFail {
            let er = NSError(domain: "test domain", code: -1009, userInfo: nil)
            if let completion = completion {
                completion(.failure(er))
            }
        }
            
            dataManagerClass.fetchArticles(withAPI: .getContents(pageIndex: nil, pageSize: nil), refresh: refresh ?? false)
            {
                result in
                switch result
                {
                case .failure: self.articles = nil; self.metaData = nil
                case .success(let data): self.articles = data.content; self.metaData = data.metadata
                }
                if let completion = completion {
                    completion(result)
                }
            }
    }
    
}
