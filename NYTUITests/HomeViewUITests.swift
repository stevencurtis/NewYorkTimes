//
//  HomeViewUITests.swift
//  NYTUITests
//
//  Created by Steven Curtis on 04/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import XCTest

class HomeViewUITests: XCTestCase {
    
    let app = XCUIApplication()

    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    func testSearchBar() {
        let searchBar = app.searchFields["Search stories"]
        XCTAssertTrue(searchBar.exists)
    }
    
    func testContentsListPopulated() {
        // load from API call
        sleep(5)
        let cell = app.collectionViews.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.exists)
    }

}
