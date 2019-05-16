//
//  SearchArticleTest.swift
//  NYTTests
//
//  Created by Steven Curtis on 05/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import XCTest
@testable import NYT


class SearchArticleTest: XCTestCase {

    var article: Data?
    var articleMultimediaMissingString: Data?

    
    override func setUp() {
        article = Data(articleString.utf8)
        articleMultimediaMissingString = Data(articleMultimediaString.utf8)
    }
    
    func testSimpleSearchArticlePublishedDate() {
        let decoded = try! JSONDecoder().decode(Article.self, from: article!)
        XCTAssertEqual( decoded.published_date_string , "2019-04-30T20:00:00-04:00")
    }
    
    func testSimpleSearchArticleDateType() {
        let decoded = try! JSONDecoder().decode(Article.self, from: article!)
        XCTAssertEqual( decoded.published_date , Date(timeIntervalSince1970: 1556668800)  )
    }
    
    // as multimedia can be "" in this JSON string, check init for missing properties
    func testArticleDateTypeMissingMultimediaAsString() {
        let decoded = try! JSONDecoder().decode(Article.self, from: articleMultimediaMissingString!)
        XCTAssertEqual( decoded.multimedia , nil  )
    }


}
