//
//  HomeViewModel.swift
//  NYT
//
//  Created by Steven Curtis on 06/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation


public protocol HomeViewModelProtocol {
    func retrieveImage(imgURL: String, completion: @escaping (Result<Data, Error>) -> Void)
    func fetchMore(completion: ((_ result: Result<(content: [DisplayContent], metadata: DisplayContentMetaData, refresh: Bool), Error>) -> Void)?)
    func fetchArticle(refresh: Bool?, completion: ((_ result: Result<(content: [DisplayContent], metadata: DisplayContentMetaData, refresh: Bool), Error>) -> Void)?)
    var articlesDidChange: ((([DisplayContent]?, DisplayContentMetaData?)) -> Void)? { get set }
    var articles : [DisplayContent]? { get }
    var metaData : DisplayContentMetaData? { get }
}

public class HomeViewModel {
    // MARK: - Properties
    
    private var dataManagerClass: DataManagerProtocol

    public var articles : [DisplayContent]? {
        didSet {
            articlesDidChange?((articles, metaData))
        }
    }
    
    public var metaData : DisplayContentMetaData?
    public var articlesDidChange: ((([DisplayContent]?, DisplayContentMetaData?)) -> Void)?

    // MARK: - Initialization
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
}

// MARK: - Public methods

extension HomeViewModel {
    
    public func retrieveImage(imgURL: String, completion: @escaping (Result<Data, Error>) -> Void) {
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
    
    public func fetchMore(completion: ((_ result: Result<(content: [DisplayContent], metadata: DisplayContentMetaData, refresh: Bool), Error>) -> Void)? = nil)
    {
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
    
    public func fetchArticle(refresh: Bool? = false, completion: ((_ result: Result<(content: [DisplayContent], metadata: DisplayContentMetaData, refresh: Bool), Error>) -> Void)? = nil)
    {
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

// MARK: - Private methods

extension HomeViewModel : HomeViewModelProtocol {}
