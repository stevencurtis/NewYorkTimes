//
//  StringtruncTest.swift
//  NYTTests
//
//  Created by Steven Curtis on 08/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import XCTest
@testable import NYT


class StringtruncTest: XCTestCase {

    override func setUp() {
    }
    
    let helloString = "Hello"
    let emptyString = ""
    
    func testSimpleZeroTrunc() {
        XCTAssertEqual(helloString.trunc(length: 0), "Hello")
    }
    
    func testSimpleTwoTrunc() {
        XCTAssertEqual(helloString.trunc(length: 2), "He...")
    }
    
    func testSimpleThreeTrunc() {
        XCTAssertEqual(helloString.trunc(length: 3), "Hel...")
    }
    
    func testSimpleLongerTrunc() {
        XCTAssertEqual(helloString.trunc(length: 100), "Hello")
    }
    
    func testEmptyTrunc() {
        XCTAssertEqual(emptyString.trunc(length: 0), "")
    }
    
    func testEmptyLongerTrunc() {
        XCTAssertEqual(emptyString.trunc(length: 1), "")
    }
    
    func testNegativeTrunc() {
        XCTAssertEqual(helloString.trunc(length: -1), "Hello")
    }
    
    func testLargeNegativeTrunc() {
        XCTAssertEqual(helloString.trunc(length: -100), "Hello")
    }
    
    func testNegativeEmptyTrunc() {
        XCTAssertEqual(emptyString.trunc(length: -1), "")
    }
    
    func testLargeNegativeEmptyTrunc() {
        XCTAssertEqual(emptyString.trunc(length: -100), "")
    }

}
