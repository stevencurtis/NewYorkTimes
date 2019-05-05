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
    
    override func setUp() {
        super.setUp()
        let bundle = Bundle(for: ArticleCollectionViewCell.self)
        cell = (bundle.loadNibNamed("ArticleCollectionViewCell", owner: nil)!.first as! ArticleCollectionViewCell)
    }
    
    func testCell(){
        
        let dc = DisplayContent(title: "test", abstract: "abs", thumbnailImageString: "tbstr", date: "data", image: "imgStr")
        
        cell.configure(with: dc)
        XCTAssertEqual(cell.titleLabel.text, dc.title)
        XCTAssertEqual(cell.dateLabel.text, dc.date)
    }

}
