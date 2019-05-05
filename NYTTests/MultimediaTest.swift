//
//  MultimediaTest.swift
//  NYTTests
//
//  Created by Steven Curtis on 05/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import XCTest
@testable import NYT


class MultimediaTest: XCTestCase {
    
    var mm: Data?
    var mmerror: Data?
    
    func testMultimedia() {
        let decoded = try! JSONDecoder().decode(Multimedia.self, from: mm!)
        XCTAssertEqual( decoded.url , "https://static01.nyt.com/images/2019/04/19/world/30dc-emoluments/30dc-emoluments-mediumThreeByTwo440.jpg")
    }
    
    func testMalformedMultimediaThrows() {
        XCTAssertThrowsError(try JSONDecoder().decode(Multimedia.self, from: mmerror!)) { error in
            if case .dataCorrupted(let key)? = error as? DecodingError {
                let custerr = key.underlyingError! as NSError
                print ("code", custerr.code )
                XCTAssertEqual(3840, custerr.code)
                
            }
        }
    }
    
    
    override func setUp() {
        let mmString = """
        {
          "url": "https://static01.nyt.com/images/2019/04/19/world/30dc-emoluments/30dc-emoluments-mediumThreeByTwo440.jpg",
          "format": "mediumThreeByTwo440",
          "height": 293,
          "width": 440,
          "type": "image",
          "subtype": "photo",
          "caption": "The Trump International Hotel in Washington.",
          "copyright": "Gabriella Demczuk for The New York Times"
        }
"""
        mm = Data(mmString.utf8)
        
        
        let mmErrorString = """
        {
                      "junk:
        }
"""
        mmerror = Data(mmErrorString.utf8)
        
    }
    
    
    
}
