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
    
    override func setUp() {
        mm = Data(multimediaString.utf8)
        mmerror = Data(multimediaErrorString.utf8)
    }
    
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
    
    func testMultimediaEauality() {
        let decoded = try! JSONDecoder().decode(Multimedia.self, from: mm!)
        XCTAssertEqual( decoded == decoded , true)
    }


    
    
    
}
