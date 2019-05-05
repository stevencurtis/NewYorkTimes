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

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testDownloadString(){

        let expectation = XCTestExpectation(description: #function)
        
        let allStr = "https://api.nytimes.com/svc/news/v3/content/all/all.json?api-key=" + APIKeys.APIKey
        
        let hm = HTTPManager()
        hm.get(urlString: allStr) { result in
            switch result {
            case .failure(let error):
                XCTAssertNil(error)
                
            case .success(let data):
                XCTAssertNotNil(data)
                
            }
            expectation.fulfill()
            
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    
    func testDownloadSearchString(){
        
        let expectation = XCTestExpectation(description: #function)
        
        let allStr = "https://api.nytimes.com/svc/search/v2/articlesearch.json?q=election&api-key=" + APIKeys.APIKey
        
        let hm = HTTPManager()
        hm.get(urlString: allStr) { result in
            switch result {
            case .failure(let error):
                XCTAssertNil(error)
                
            case .success(let data):
                XCTAssertNotNil(data)
                
            }
            expectation.fulfill()
            
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    
    func testDownloadURL(){
        
        let expectation = XCTestExpectation(description: #function)
        let allStr = "https://api.nytimes.com/svc/news/v3/content/all/all.json?api-key=" + APIKeys.APIKey
        
        let allstrURL = URL(string: allStr)
        let hm = HTTPManager()
        hm.get(url: allstrURL!) { result in
            switch result {
            case .failure(let error):
                XCTAssertNil(error)
                
            case .success(let data):
                XCTAssertNotNil(data)
                
            }
            expectation.fulfill()
            
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testDownloadSearchURL(){
        
        let expectation = XCTestExpectation(description: #function)
        let allStr = "https://api.nytimes.com/svc/search/v2/articlesearch.json?q=election&api-key=" + APIKeys.APIKey
        
        let allstrURL = URL(string: allStr)
        let hm = HTTPManager()
        hm.get(url: allstrURL!) { result in
            switch result {
            case .failure(let error):
                XCTAssertNil(error)
                
            case .success(let data):
                XCTAssertNotNil(data)
                
            }
            expectation.fulfill()
            
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testInvalidString(){
        let expectation = XCTestExpectation(description: #function)
        
        let allStr = "asdf" + APIKeys.APIKey
        
        let hm = HTTPManager()
        hm.get(urlString: allStr) { result in
            switch result {
            case .failure(let error):
                let custerr = error as NSError
                XCTAssertEqual(custerr.code, -1002)
            case .success(let data):
                XCTAssertNil(data)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testInvalidURL(){
        
        let expectation = XCTestExpectation(description: #function)
        let allStr = "https://adfsewef///*" + APIKeys.APIKey
        
        let allstrURL = URL(string: allStr)
        let hm = HTTPManager()
        hm.get(url: allstrURL!) { result in
            switch result {
            case .failure(let error):
                let custerr = error as NSError
                XCTAssertEqual(custerr.code, -1003)
            case .success(let data):
                XCTAssertNotNil(data)
                
            }
            expectation.fulfill()
            
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
}
