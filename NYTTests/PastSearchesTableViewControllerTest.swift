//
//  PastSearchesViewControllerTest.swift
//  NYTTests
//
//  Created by Steven Curtis on 05/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import XCTest
@testable import NYT

class PastSearchesTableViewControllerTest: XCTestCase {
    
    var pstVCNib: PastSearchesTableViewController!

    override func setUp() {
        pstVCNib =  (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "past") as! PastSearchesTableViewController)
        UIApplication.shared.keyWindow?.rootViewController = pstVCNib    }
    
    
    func testPastSearchesThree(){
        pstVCNib.pastSearches = ["1","2","3"]
        let numberOfRowsInSection = pstVCNib.tableView(UITableView(), numberOfRowsInSection: 0)
        XCTAssertEqual(numberOfRowsInSection, 3)
    }

    func testPastSearchesZero(){
        pstVCNib.pastSearches = []
        let numberOfRowsInSection = pstVCNib.tableView(UITableView(), numberOfRowsInSection: 0)
        XCTAssertEqual(numberOfRowsInSection, 0)
    }
    
    func testPastSearchesOverTen(){
        pstVCNib.pastSearches = ["1","2","3","4","5","6","7","8","9","10","11"]
        let numberOfRowsInSection = pstVCNib.tableView(UITableView(), numberOfRowsInSection: 0)
        XCTAssertEqual(numberOfRowsInSection, 11)
    }
    
    func testFirstThreeCellText(){
        pstVCNib.pastSearches = ["0","1","2"]
        for i in 0...2 {
            let cell = pstVCNib.tableView(pstVCNib.tableView, cellForRowAt: IndexPath(row: i, section: 0))
            XCTAssertEqual(cell.textLabel?.text, i.description)
        }
    }
    
    func testFirstTenCellText(){
        pstVCNib.pastSearches = []
        for i in 0...9 {
            pstVCNib.pastSearches.append(i.description)
        }
        for j in 0...9 {
            let cell = pstVCNib.tableView(pstVCNib.tableView, cellForRowAt: IndexPath(row: j, section: 0))
            XCTAssertEqual(cell.textLabel?.text, j.description)
        }
    }
}
