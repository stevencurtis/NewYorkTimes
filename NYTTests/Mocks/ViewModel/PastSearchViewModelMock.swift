//
//  PastSearchViewModelMock.swift
//  NYTTests
//
//  Created by Steven Curtis on 08/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation
@testable import NYT

protocol PastSearchMockProtocol{
    func setForFailure(willFail: Bool)


}
typealias PSMock = PastSearchModelProtocol & PastSearchMockProtocol

class PastSearchVewModelMock : PSMock {
    var searchesDidChange: (([String]?) -> Void)?
    
    var willFail: Bool = false

    var previousSearches: [String]?
    
    private var dataManagerClass: DataManagerProtocol
    var kwdsDB : RecentKeywordsProtocol = RecentKeywords()


    init(dataManager: DataManagerProtocol, kwdsDB: RecentKeywordsProtocol? = nil, previousSearches: [String]? = nil) {
        self.dataManagerClass = dataManager
        
        self.previousSearches = previousSearches
        if let kwds = kwdsDB {
            self.kwdsDB = kwds
        }
    }
    
    func setForFailure(willFail: Bool) {
        self.willFail = willFail
    }
    
    func addSearchTerm(_ searchTerms: String) { }
    
    func fetchArticle(searchTerms: String, completion: @escaping ((Result<(content: [DisplayContent], metadata: DisplayContentMetaData, refresh: Bool), Error>) -> Void)) {
        if willFail {
            let er = NSError(domain: "test domain", code: -1009, userInfo: nil)
            completion(.failure(er))
            return
        }
        
        dataManagerClass.fetchArticles(withAPI: .getContents(pageIndex: nil, pageSize: nil), refresh: true)
        {
            result in
            switch result {
            case .failure, .success: completion(result)
            }
        }
    }
    
    func fetchContents(refresh: Bool?, completion: ((Result<(content: [DisplayContent], metadata: DisplayContentMetaData, refresh: Bool), Error>) -> Void)?) {
        dataManagerClass.clearDM()
        
        if willFail {
            let er = NSError(domain: "test domain", code: -1009, userInfo: nil)
            if let completion = completion {
                completion(.failure(er))
            }
            return
        }
        
        dataManagerClass.fetchArticles(withAPI: .getContents(pageIndex: pageIndex, pageSize: pageSize), refresh: true)
        {  result in
            switch result {
            case .failure, .success: break
            }
            if let completion = completion {
                completion(result)
            }
        }
        
        
    }
    
    func fetchSearches() {
        previousSearches = kwdsDB.returnkeywords(forKey: UserDefaultsKey) ?? []
    }
    
}
