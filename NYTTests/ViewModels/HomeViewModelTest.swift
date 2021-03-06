
//
//  HomeViewModelTest.swift
//  NYTTests
//
//  Created by Steven Curtis on 08/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import XCTest
@testable import NYT

class HomeViewModelTest: XCTestCase {
    
    var homeViewModel : HomeViewModel?
    var dataManager : DMMock?

    override func setUp() {
        dataManager = DataManagerMock()
        homeViewModel = HomeViewModel(dataManager: dataManager!)
    }    
    
    func testInitialViewModel() {
        XCTAssertEqual(homeViewModel?.articles, nil)
    }
    
    func testViewModelSingle() {
        dataManager?.setArticles(displayContent: [singleDisplayContent])
        dataManager?.fetchArticles(withAPI: .getContents(pageIndex: nil, pageSize: nil), refresh: false) {
            result in
            return
        }
        XCTAssertEqual(homeViewModel?.articles, ([singleDisplayContent]))
    }

    func testViewModelDouble() {
        dataManager?.setArticles(displayContent: [singleDisplayContent, doubleDisplayContent])
        dataManager?.fetchArticles(withAPI: .getContents(pageIndex: nil, pageSize: nil), refresh: false) {
            result in
            return
        }
        XCTAssertEqual(homeViewModel?.articles, [singleDisplayContent,doubleDisplayContent])
    }

    func testViewModelSingleMetaData() {
        dataManager?.setArticles(displayContent: [singleDisplayContent])
        dataManager?.fetchArticles(withAPI: .getContents(pageIndex: nil, pageSize: nil), refresh: false) {
            result in
            return
        }
        XCTAssertEqual(homeViewModel?.metaData?.hits, 1)
    }

    func testViewModelDoubleMetaData() {
        dataManager?.setArticles(displayContent: [singleDisplayContent,doubleDisplayContent])
        dataManager?.fetchArticles(withAPI: .getContents(pageIndex: nil, pageSize: nil), refresh: false) {
            result in
            return
        }
        XCTAssertEqual(homeViewModel?.metaData?.hits, 2)
    }

    func testViewModelFailfetchMore() {
        let expectation = XCTestExpectation(description: #function)
        dataManager?.setForFailure(willFail: true)
        homeViewModel?.fetchMore(){ res in
            switch res {
            case .failure: expectation.fulfill()
            case .success: break
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testViewModelFetchMore() {
        let expectation = XCTestExpectation(description: #function)
        dataManager?.setArticles(displayContent: [singleDisplayContent])

        homeViewModel?.fetchMore(){ res in
            switch res {
            case .failure: break
            case .success:
                expectation.fulfill()
            }
            XCTAssertEqual(self.homeViewModel?.articles, [singleDisplayContent])
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    
    func testViewModelFailfetchArticle() {
        let expectation = XCTestExpectation(description: #function)
        dataManager?.setForFailure(willFail: true)
        homeViewModel?.fetchArticle(){ res in
            switch res {
            case .failure: expectation.fulfill()
            case .success: break
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    
    func testViewModelFetchfetchArticle() {
        let expectation = XCTestExpectation(description: #function)
        dataManager?.setArticles(displayContent: [singleDisplayContent])
        
        homeViewModel?.fetchArticle(){ res in
            switch res {
            case .failure: break
            case .success:
                expectation.fulfill()
            }
            XCTAssertEqual(self.homeViewModel?.articles, [singleDisplayContent])
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testViewModelFailfetchImage() {
        let expectation = XCTestExpectation(description: #function)
        dataManager?.setForFailure(willFail: true)
        homeViewModel?.retrieveImage(imgURL: imgString){ res in
            switch res {
            case .failure: expectation.fulfill()
            case .success: break
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testViewModelfetchImage() {
        let expectation = XCTestExpectation(description: #function)

        homeViewModel?.retrieveImage(imgURL: imgString){ res in
            switch res {
            case .failure: break
            case .success(let data):
                if let img = UIImage(data: data) {
                    let localImage = UIImage(named: "test.png", in: Bundle(for: type(of: self)), compatibleWith: nil)
                    if localImage?.pngData() == img.pngData() {
                        expectation.fulfill()
                    }
                }
            }
        }
        wait(for: [expectation], timeout: 3.0)
    }

    
}




