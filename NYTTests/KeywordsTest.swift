//
//  KeywordsTest.swift
//  NYTTests
//
//  Created by Steven Curtis on 05/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import XCTest
@testable import NYT


class KeywordsTest: XCTestCase {

    func testSimpleWordToArray() {
        let words = ["a","b","c"]
        let result = RecentKeywords.addWordToArray(words, "d")
        XCTAssertEqual(result.words, ["a","b","c","d"])
        XCTAssertEqual(result.set, true)
    }
    
    func testAddLessTen() {
        savedSearches = 10
        let words = ["1","2","3","4","5","6","7","8","9","10"]
        let result = RecentKeywords.addWordToArray(words, "11")
        XCTAssertEqual(result.words, ["2", "3", "4", "5", "6", "7", "8", "9", "10", "11"])
        XCTAssertEqual(result.set, true)
    }
    
    func testRepeatedElement() {
        savedSearches = 10
        let words = ["1","2","3","4","5","6","7","8","9","10"]
        let result = RecentKeywords.addWordToArray(words, "10")
        XCTAssertEqual(result.words, ["1","2", "3", "4", "5", "6", "7", "8", "9", "10"])
        XCTAssertEqual(result.set, false)
    }
    
    func testRepeatedElementOverflow() {
        savedSearches = 10
        let words = ["1","2","3","4","5","6","7","8","9","10","11"]
        let result = RecentKeywords.addWordToArray(words, "11")
        XCTAssertEqual(result.words, ["2", "3", "4", "5", "6", "7", "8", "9", "10","11"])
        XCTAssertEqual(result.set, false)
    }
    
    func testAddToNone() {
        savedSearches = 10
        let words : [String] = []
        let result = RecentKeywords.addWordToArray(words, "1")
        XCTAssertEqual(result.words, ["1"])
        XCTAssertEqual(result.set, true)

    }
    
    func testAddNotOrdered() {
        savedSearches = 10
        let words = ["a","134","t","v","x"]
        let result = RecentKeywords.addWordToArray(words, "loop")
        XCTAssertEqual(result.words, ["a", "134", "t", "v", "x", "loop"])
        XCTAssertEqual(result.set, true)

    }
    
    func testAddNotOrderedOverflow() {
        savedSearches = 10
        let words = ["a","134","t","v","x","<","d","l","[","0","mn","asd"]
        let result = RecentKeywords.addWordToArray(words, "loop")
        XCTAssertEqual(result.words, ["v", "x", "<", "d", "l", "[", "0", "mn", "asd", "loop"])
        XCTAssertEqual(result.set, true)

    }
    
    func testZeroSearches() {
        savedSearches = 0
        let words = ["a","134","t","v","x","<","d","l","[","0","mn","asd"]
        let result = RecentKeywords.addWordToArray(words, "loop")
        XCTAssertEqual(result.words, [])
        XCTAssertEqual(result.set, false)

    }
    
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
