//
//  PastSearchesUITests.swift
//  NYTUITests
//
//  Created by Steven Curtis on 05/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import XCTest

class PastSearchesUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    func testDetails() {
        let searchBar = app.searchFields["Search stories"]
        searchBar.tap()
        searchBar.typeText("Election")
        app.keyboards.buttons["Search"].tap()
        sleep(1)
        app.collectionViews.children(matching: .cell).element(boundBy: 0).tap()
    }
    
}
