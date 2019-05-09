//
//  ConstantsApiTest.swift
//  NYTTests
//
//  Created by Steven Curtis on 05/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import XCTest
@testable import NYT

class ConstantsApiTest: XCTestCase {

    override func setUp() {
    }

    func testContentsPath(){
        let res = path(api: API.getContents(pageIndex: nil, pageSize: nil) )
        XCTAssertEqual(res, apiv3)
    }
    
    func testSearchPath(){
        let res = path(api: API.searchArticles(query: "Election", pageIndex: 1))
        XCTAssertEqual(res, apiv2)
    }
    
}
