//
//  PastSearchViewModelTest.swift
//  NYTTests
//
//  Created by Steven Curtis on 08/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import XCTest
@testable import NYT


class PastSearchViewModelTest: XCTestCase {

    var pastViewModel : PastSearchViewModel?
    var dataManager : DMMock?
    var keywordsDB : RecentKeywordsProtocol?
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        dataManager = DataManagerMock()
        keywordsDB = RecentKeywordsMock()
        keywordsDB?.set("1", forKey: "")
        pastViewModel = PastSearchViewModel(dataManager: dataManager!, kwdsDB: keywordsDB, previousSearches: nil)

    }

    func testFetchSearches() {
        pastViewModel?.addSearchTerm("test")
        XCTAssertEqual(keywordsDB?.returnkeywords(forKey: ""), ["1", "test"])
    }

    func testFetchWithPreviousSearches() {
        pastViewModel?.previousSearches = ["last"]

        pastViewModel?.addSearchTerm("test")
        XCTAssertEqual(keywordsDB?.returnkeywords(forKey: ""), ["1", "test"])
    }
    
    
    func testFetchWithPreviousRepeated() {
        pastViewModel?.previousSearches = ["1"]
        
        pastViewModel?.addSearchTerm("1")
        XCTAssertEqual(keywordsDB?.returnkeywords(forKey: ""), ["1", "1"])
    }
    
}
