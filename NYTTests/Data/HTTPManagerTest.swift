//
//  HTTPManagerTest.swift
//  NYTTests
//
//  Created by Steven Curtis on 05/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import XCTest
@testable import NYT

class HTTPManagerTest: XCTestCase {

    override func setUp() { }
    var urlSession : URLSessionMock?
    var httpManager: HTTPManager?
    
    func testSuccessURLResponse(){
        urlSession = URLSessionMock()
        httpManager = HTTPManager(session: urlSession!)
        
        let expectation = XCTestExpectation(description: #function)
        let data = Data(searchResultsString.utf8)
        urlSession?.data = data
        
        let url = URL(fileURLWithPath: "url")
        
        httpManager?.get(url: url) {
            result in
            XCTAssertNotNil(result)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    
    func testFailureURLResponse(){
        urlSession = URLSessionMock()
        httpManager = HTTPManager(session: urlSession!)
        
        let expectation = XCTestExpectation(description: #function)
        let error = NSError(domain:"", code:-1009, userInfo:[ NSLocalizedDescriptionKey: "Internet Offline"]) as Error
        urlSession?.error = error
        
        let url = URL(fileURLWithPath: "url")
        
        httpManager?.get(url: url) {
            result in
            switch result {
            case .failure(let error): XCTAssertNotNil(error)
            case .success(let data): XCTAssertNil(data)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testSuccessURLStringResponse(){
        urlSession = URLSessionMock()
        httpManager = HTTPManager(session: urlSession!)
        
        let expectation = XCTestExpectation(description: #function)
        let data = Data(searchResultsString.utf8)
        urlSession?.data = data
        
        let url = "url"
        
        httpManager?.get(urlString: url) {
            result in
            XCTAssertNotNil(result)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testFailureURLStringResponse(){
        urlSession = URLSessionMock()
        httpManager = HTTPManager(session: urlSession!)
        
        let expectation = XCTestExpectation(description: #function)
        let error = NSError(domain:"", code:-1009, userInfo:[ NSLocalizedDescriptionKey: "Internet Offline"]) as Error
        urlSession?.error = error
        
        let url = "url"

        httpManager?.get(urlString: url) {
            result in
            switch result {
            case .failure(let error): XCTAssertNotNil(error)
            case .success(let data): XCTAssertNil(data)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
}
