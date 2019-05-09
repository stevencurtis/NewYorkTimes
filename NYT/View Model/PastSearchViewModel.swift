//
//  PastSearchViewModel.swift
//  NYT
//
//  Created by Steven Curtis on 07/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation

public protocol PastSearchModelProtocol {
    var searchesDidChange: (([String]?) -> Void)? { get set }
    var previousSearches : [String]? { get set }
    func addSearchTerm(_ searchTerms : String)
    func fetchArticle(searchTerms: String, completion: @escaping ((_ result: Result<(content: [DisplayContent], metadata: DisplayContentMetaData, refresh: Bool), Error>) -> Void) )
    func fetchContents(refresh: Bool?, completion: ((_ result: Result<(content: [DisplayContent], metadata: DisplayContentMetaData, refresh: Bool), Error>) -> Void)? )
    func fetchSearches()
}

class PastSearchViewModel {

    var previousSearches : [String]? {
        didSet {
            searchesDidChange?(previousSearches)
        }
    }
    
    private var dataManagerClass: DataManagerProtocol
    var kwdsDB : RecentKeywordsProtocol = RecentKeywords()

    init(dataManager: DataManagerProtocol, kwdsDB: RecentKeywordsProtocol? = nil, previousSearches: [String]? = nil) {
        self.dataManagerClass = dataManager
        self.previousSearches = previousSearches
        if let kwds = kwdsDB {
            self.kwdsDB = kwds
        }
    }
    
    var searchesDidChange: (([String]?) -> Void)?
    
    /// retrieve searched terms from the database
    func fetchSearches() {
        previousSearches = kwdsDB.returnkeywords(forKey: UserDefaultsKey) ?? []
    }
    
    func addSearchTerm(_ searchTerms : String) {
        let newSearch = searchTerms
        guard var searches = previousSearches else {previousSearches = [newSearch]; kwdsDB.set(newSearch, forKey: UserDefaultsKey); return}
        
        for search in searches.enumerated() {
            if search.element == newSearch {
                searches.remove(at: search.offset)
            }
        }
        searches.insert(newSearch, at: 0)
        while searches.count > savedSearches {
            searches.removeLast()
        }
        previousSearches = searches
        kwdsDB.set(newSearch, forKey: UserDefaultsKey)
    }

}

extension PastSearchViewModel {
    func fetchArticle(searchTerms: String, completion: @escaping ((_ result: Result<(content: [DisplayContent], metadata: DisplayContentMetaData, refresh: Bool), Error>) -> Void) ) {
        
        dataManagerClass.fetchArticles(withAPI: .searchArticles(query: searchTerms, pageIndex: nil), refresh: true)
        {
            result in
            switch result {
            case .failure, .success: completion(result)
            }
        }
    }
    
    func fetchContents(refresh: Bool? = false, completion: ((_ result: Result<(content: [DisplayContent], metadata: DisplayContentMetaData, refresh: Bool), Error>) -> Void)? = nil ) {
        dataManagerClass.clearDM()
        
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
    
}


extension PastSearchViewModel : PastSearchModelProtocol {}
