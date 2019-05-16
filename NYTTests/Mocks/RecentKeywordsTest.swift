//
//  KeywordsTest.swift
//  NYTTests
//
//  Created by Steven Curtis on 05/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import XCTest
@testable import NYT


class RecentKeywordsTest: XCTestCase {

    func testOrderSimpleWordToArray() {
        let words = ["a","b","c"]
        let result = RecentKeywords().addWordToArray(words, "d")
        XCTAssertEqual(result.words, ["d","a","b","c"])
    }
    
    func testSetSimpleWordToArray() {
        let words = ["a","b","c"]
        let result = RecentKeywords().addWordToArray(words, "d")
        XCTAssertEqual(result.set, true)
    }
    
    func testOrderAddLessTen() {
        savedSearches = 10
        let words = ["1","2","3","4","5","6","7","8","9","10"]
        let result = RecentKeywords().addWordToArray(words, "11")
        XCTAssertEqual(result.words, ["11", "2", "3", "4", "5", "6", "7", "8", "9", "10"])
    }
    
    func testSetAddLessTen() {
        savedSearches = 10
        let words = ["1","2","3","4","5","6","7","8","9","10"]
        let result = RecentKeywords().addWordToArray(words, "11")
        XCTAssertEqual(result.set, true)
    }
    
    func testOrderRepeatedElement() {
        savedSearches = 10
        let words = ["1","2","3","4","5","6","7","8","9","10"]
        let result = RecentKeywords().addWordToArray(words, "10")
        XCTAssertEqual(result.words, ["10","1","2", "3", "4", "5", "6", "7", "8", "9"])
    }
    
    func testSetRepeatedElement() {
        savedSearches = 10
        let words = ["1","2","3","4","5","6","7","8","9","10"]
        let result = RecentKeywords().addWordToArray(words, "10")
        XCTAssertEqual(result.set, true) // as the order has changed
    }
    
    func testOrderRepeatedElementOverflow() {
        savedSearches = 10
        let words = ["1","2","3","4","5","6","7","8","9","10","11"]
        let result = RecentKeywords().addWordToArray(words, "11")
        XCTAssertEqual(result.words, ["11","2", "3", "4", "5", "6", "7", "8", "9", "10"])
    }
    
    func testSetRepeatedElementOverflow() {
        savedSearches = 10
        let words = ["1","2","3","4","5","6","7","8","9","10","11"]
        let result = RecentKeywords().addWordToArray(words, "11")
        XCTAssertEqual(result.set, true) // as the order has changed
    }
    
    func testOrderAddToNone() {
        savedSearches = 10
        let words : [String] = []
        let result = RecentKeywords().addWordToArray(words, "1")
        XCTAssertEqual(result.words, ["1"])
    }
    
    func testSetAddToNone() {
        savedSearches = 10
        let words : [String] = []
        let result = RecentKeywords().addWordToArray(words, "1")
        XCTAssertEqual(result.set, true)
    }
    
    func testOrderAddNotOrdered() {
        savedSearches = 10
        let words = ["a","134","t","v","x"]
        let result = RecentKeywords().addWordToArray(words, "loop")
        XCTAssertEqual(result.words, [ "loop", "a", "134", "t", "v", "x"])
    }
    
    func testSetAddNotOrdered() {
        savedSearches = 10
        let words = ["a","134","t","v","x"]
        let result = RecentKeywords().addWordToArray(words, "loop")
        XCTAssertEqual(result.set, true)
    }
    
    func testOrderAddNotOrderedOverflow() {
        savedSearches = 10
        let words = ["a","134","t","v","x","<","d","l","[","0","mn","asd"]
        let result = RecentKeywords().addWordToArray(words, "loop")
        XCTAssertEqual(result.words, ["loop", "v", "x", "<", "d", "l", "[", "0", "mn", "asd"])
    }
    
    func testSetAddNotOrderedOverflow() {
        savedSearches = 10
        let words = ["a","134","t","v","x","<","d","l","[","0","mn","asd"]
        let result = RecentKeywords().addWordToArray(words, "loop")
        XCTAssertEqual(result.set, true)
    }
    
    func testOrderZeroSearches() {
        savedSearches = 0
        let words = ["a","134","t","v","x","<","d","l","[","0","mn","asd"]
        let result = RecentKeywords().addWordToArray(words, "loop")
        XCTAssertEqual(result.words, [])
    }
    
    func testSetZeroSearches() {
        savedSearches = 0
        let words = ["a","134","t","v","x","<","d","l","[","0","mn","asd"]
        let result = RecentKeywords().addWordToArray(words, "loop")
        XCTAssertEqual(result.set, false)
    }
    
}
