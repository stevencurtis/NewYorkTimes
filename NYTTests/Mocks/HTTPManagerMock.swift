//
//  MockHTTPManager.swift
//  NYTTests
//
//  Created by Steven Curtis on 04/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import XCTest
@testable import NYT

class HTTPManagerMock: HTTPManagerProtocol {
    
    func get(urlString: String, completionBlock: @escaping (Result<Data, Error>) -> Void) {
        let data = Data(contentString.utf8)
        completionBlock(.success(data))
    }
    
    func get(url: URL, completionBlock: @escaping (Result<Data, Error>) -> Void) {
        let data = Data(contentString.utf8)
        completionBlock(.success(data))
    }
}

class MockHTTPManagerImage: HTTPManagerProtocol {
    
    func get(urlString: String, completionBlock: @escaping (Result<Data, Error>) -> Void) {
        let localImage = UIImage(named: "test.png", in: Bundle(for: type(of: self)), compatibleWith: nil)!
        let data = localImage.pngData()
        completionBlock(.success(data!))
    }
    
    func get(url: URL, completionBlock: @escaping (Result<Data, Error>) -> Void) {
        let localImage = UIImage(named: "test.png")
        let data = localImage!.pngData()
        completionBlock(.success(data!))
    }

}

class MockHTTPManagerSearch: HTTPManagerProtocol {
    
    func get(urlString: String, completionBlock: @escaping (Result<Data, Error>) -> Void) {
        let data = Data(searchResultsString.utf8)
        completionBlock(.success(data))
        
    }
    
    func get(url: URL, completionBlock: @escaping (Result<Data, Error>) -> Void) {
        let data = Data(searchResultsString.utf8)
        completionBlock(.success(data))
    }
}

enum CustomError: String, Error {
    case networkError
}

class MockHTTPManagerFailure: HTTPManagerProtocol {
    
    func get(urlString: String, completionBlock: @escaping (Result<Data, Error>) -> Void) {
        let er = NSError(domain: "test domain", code: -1009, userInfo: nil)
        completionBlock(.failure(er))
    }
    
    func get(url: URL, completionBlock: @escaping (Result<Data, Error>) -> Void) {
        let er = NSError(domain: "test domain", code: -1009, userInfo: nil)
        completionBlock(.failure(er))
    }
    
    func returnShared() -> HTTPManagerProtocol {
        return MockHTTPManagerFailure.shared
    }
    static let shared: MockHTTPManagerFailure = MockHTTPManagerFailure()
}
