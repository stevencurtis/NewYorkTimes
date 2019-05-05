//
//  DateStringTest.swift
//  NYTTests
//
//  Created by Steven Curtis on 04/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import XCTest
@testable import NYT

class DateStringTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testDate() {
        var components = DateComponents()
        components.year = 2019
        components.month = 12
        components.day = 31
        let date = Calendar.current.date(from: components)
        let dateString = date?.dateString
        
        XCTAssertEqual(dateString, "Dec 31, 2019")
    }

    func testFeb29() {
        var components = DateComponents()
        components.year = 2016
        components.month = 02
        components.day = 29
        let date = Calendar.current.date(from: components)
        let dateString = date?.dateString
        
        XCTAssertEqual(dateString, "Feb 29, 2016")
    }
    
    func testBeginYear() {
        var components = DateComponents()
        components.year = 2020
        components.month = 01
        components.day = 01
        let date = Calendar.current.date(from: components)
        let dateString = date?.dateString
        
        XCTAssertEqual(dateString, "Jan 01, 2020")
    }
    
    func testFutureYear() {
        var components = DateComponents()
        components.year = 2030
        components.month = 04
        components.day = 07
        let date = Calendar.current.date(from: components)
        let dateString = date?.dateString
        
        XCTAssertEqual(dateString, "Apr 07, 2030")
    }

    func testWrongDay() {
        var components = DateComponents()
        components.year = 2030
        components.month = 04
        components.day = 999
        let date = Calendar.current.date(from: components)
        let dateString = date?.dateString
        
        XCTAssertEqual(dateString, "Dec 24, 2032")
    }
    
    func testNilDay() {
        var components = DateComponents()
        components.year = 2030
        components.month = 04
        components.day = nil
        let date = Calendar.current.date(from: components)
        let dateString = date?.dateString
        XCTAssertEqual(dateString, "Apr 01, 2030")
    }
    
    func testNilMonth() {
        var components = DateComponents()
        components.year = 2030
        components.month = nil
        components.day = 01
        let date = Calendar.current.date(from: components)
        let dateString = date?.dateString
        XCTAssertEqual(dateString, "Jan 01, 2030")
    }
    
    func testNilYear() {
        var components = DateComponents()
        components.year = nil
        components.month = 05
        components.day = 01
        let date = Calendar.current.date(from: components)
        let dateString = date?.dateString
        XCTAssertEqual(dateString, "May 01, 0001")
    }
    

}
