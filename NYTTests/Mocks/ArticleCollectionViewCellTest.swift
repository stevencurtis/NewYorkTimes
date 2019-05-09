//
//  ArticleCollectionViewCellTest.swift
//  NYTTests
//
//  Created by Steven Curtis on 04/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import XCTest
@testable import NYT

class ArticleCollectionViewCellTest: XCTestCase {

    var cell : ArticleCollectionViewCell!    
    let dc = DisplayContent(title: "test", abstract: "abs", thumbnailImageString: "tbstr", date: "data", image: "imgStr")

    override func setUp() {
        super.setUp()
        let bundle = Bundle(for: ArticleCollectionViewCell.self)
        cell = (bundle.loadNibNamed("ArticleCollectionViewCell", owner: nil)!.first as! ArticleCollectionViewCell)
                cell.configure(with: dc)
    }
    
    func testCellTitle(){
        XCTAssertEqual(cell.dateLabel.text, dc.date)
    }
    
    func testCellDate(){
        XCTAssertEqual(cell.titleLabel.text, dc.title)
    }

    
    func testCellRemove(){
        cell.clearAll()
        XCTAssertEqual(cell.titleLabel.text, "")
    }

}
