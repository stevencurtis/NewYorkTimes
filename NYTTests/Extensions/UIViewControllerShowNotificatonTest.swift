//
//  UIViewControllerShowNotificatonTest.swift
//  NYTTests
//
//  Created by Steven Curtis on 08/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import XCTest
@testable import NYT


class UIViewControllerShowNotificatonTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testPresentAlert() {

        UIApplication.shared.keyWindow?.rootViewController?.showNotification(title: "mytitle", message: "mymessage")
        
        let expectation = XCTestExpectation(description: "alert")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            XCTAssertTrue(UIApplication.shared.keyWindow?.rootViewController?.presentedViewController is UIAlertController)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1.5)
    }

    func testPresentAlertTitle() {
        
        UIApplication.shared.keyWindow?.rootViewController?.showNotification(title: "mytitle", message: "mymessage")
        
        let expectation = XCTestExpectation(description: "alert")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            XCTAssertEqual(UIApplication.shared.keyWindow?.rootViewController?.presentedViewController?.title, "mytitle")
            
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1.5)
        
    }

}
