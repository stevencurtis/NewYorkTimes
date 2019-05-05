//
//  DetailsViewUITests.swift
//  NYTUITests
//
//  Created by Steven Curtis on 05/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import XCTest

class DetailsViewUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()

    }

    func testDetails() {
        sleep(3)
        app.collectionViews.children(matching: .cell).element(boundBy: 0).tap()
        sleep(1)
        let myLabelUIElement: XCUIElement = app.staticTexts["titlelabel"]
        XCTAssertTrue(myLabelUIElement.label != "")
        
    }

}
