//
//  DisplayDetailsViewModelTest.swift
//  NYTTests
//
//  Created by Steven Curtis on 09/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import XCTest
@testable import NYT

class DisplayDetailsViewModelTest: XCTestCase {
    
    var displayViewModel : DisplayDetailsViewModel?
    var dataManager : DMMock?

    override func setUp() {
        dataManager = DataManagerMock()
        displayViewModel = DisplayDetailsViewModel(dataManager: dataManager!, contents: singleDisplayContent)
    }

    func testFailRetrieveImage() {
        let expectation = XCTestExpectation(description: #function)
        dataManager?.setForFailure(willFail: true)
        displayViewModel!.retrieveImage(imgURL: imgString) { result in
            switch result {
            case .failure(let error): XCTAssertNotNil(error); expectation.fulfill()
            case .success(let data): XCTAssertNil(data)
            }
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testSuccessRetrieveImage() {
        let expectation = XCTestExpectation(description: #function)
        displayViewModel!.retrieveImage(imgURL: imgString) { result in
            switch result {
            case .failure(let error): print (error, "image error") // User will be unaware of the silent failure here
            case .success(let data):
                if let img: UIImage = UIImage(data: data) {
                    XCTAssertNotNil(img)
                }
                expectation.fulfill()
            }
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

    
}
