//
//  DataManagerTest.swift
//  NYTTests
//
//  Created by Steven Curtis on 05/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import XCTest
@testable import NYT


class DataManagerTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testSearchDownload(){
        let expectation = XCTestExpectation(description: #function)

        let dm = DataManager(httpManager: MockHTTPManagerSearch() )
            dm.fetchArticles(withAPI: .searchArticles(query: "election", pageIndex: 0), refresh: false) { result in
                print (result)
            switch result {
            case .failure(let error):
                XCTAssertNil(error)
            case .success(let content, _, _):
                XCTAssertEqual(content.first!.abstract, "The Election Commission of India runs the elections. A former head of the federal body explains how it is done.")
                }
            expectation.fulfill()

            }
        wait(for: [expectation], timeout: 3.0)
        }
    
    
    func testSearchFailDownload(){
        let expectation = XCTestExpectation(description: #function)
        let dm = DataManager(httpManager: MockHTTPManagerSearch() )
        
        dm.fetchArticles(withAPI: .searchArticles(query: "election", pageIndex: 0), refresh: false) { result in
            print (result)
            switch result {
            case .failure(let error):
                XCTAssertNil(error)
            case .success(let content, _, _):
                XCTAssertEqual(content.first!.abstract, "The Election Commission of India runs the elections. A former head of the federal body explains how it is done.")
            }
            expectation.fulfill()
            
        }
        wait(for: [expectation], timeout: 3.0)
    }
    

    func testContentDownload(){
        let expectation = XCTestExpectation(description: #function)
        let dm = DataManager(httpManager: HTTPManagerMock())
        dm.fetchArticles(withAPI: .getContents(pageIndex: 1, pageSize: 1), refresh: false) { result in
            print (result)
            switch result {
            case .failure(let error):
                XCTAssertNil(error)
            case .success(let content, _, _):
                XCTAssertEqual(content.first!.abstract, "The copter struck a mountain outside Caracas as it was traveling to a state where President Nicol e1s Maduro appeared alongside troops in an effort to demonstrate their loyalty.")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testImageDownload(){
        let expectation = XCTestExpectation(description: #function)
        let dm = DataManager(httpManager: MockHTTPManagerImage())
        dm.fetchImageData(withURLString: "test") {result in
            switch result {
            case .failure(let error): XCTAssertNil(error)
            case .success(let data):
                let img: UIImage! = UIImage(data: data)
                XCTAssertNotNil(img)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testImageFail(){
        let expectation = XCTestExpectation(description: #function)
        let dm = DataManager(httpManager: MockHTTPManagerFailure.shared)
        dm.fetchImageData(withURLString: "test") {result in
            
            switch result {
            case .failure(let error): XCTAssertNotNil(error)
            case .success(let data):
                let img: UIImage! = UIImage(data: data)
                XCTAssertNil(img)
                
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testDMSetArticles(){
        let expectation = XCTestExpectation(description: #function)

        let dm = DataManager(httpManager: HTTPManagerMock())
        dm.fetchArticles(withAPI: .getContents(pageIndex: 1, pageSize: 1), refresh: false) { result in
            print (result)
            switch result {
            case .failure(let error):
                XCTAssertNil(error)
            case .success:
                XCTAssertEqual(dm.articles!.count, 1)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }

    func testDMClearArticles(){
        let expectation = XCTestExpectation(description: #function)
        
        let dm = DataManager(httpManager: HTTPManagerMock())
        dm.fetchArticles(withAPI: .getContents(pageIndex: 1, pageSize: 1), refresh: false) { result in
            print (result)
            switch result {
            case .failure(let error):
                XCTAssertNil(error)
            case .success:
                dm.clearDM()
                XCTAssertEqual(dm.articles!.count, 0)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
}
