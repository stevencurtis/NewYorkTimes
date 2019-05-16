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
    
    var psVC: PastSearchesTableViewController?
    var dataManager : DMMock?
    var pastSearchViewModelMock : PSMock?
    var psVCNib: PastSearchesTableViewController?
    
    override func setUp() {
        dataManager = DataManagerMock()
        
        let mockKwds = RecentKeywordsMock()
        mockKwds.set("AAA", forKey: UserDefaultsKey)
        mockKwds.set("BB", forKey: UserDefaultsKey)
        mockKwds.set("CCC", forKey: UserDefaultsKey)
        pastSearchViewModelMock = PastSearchVewModelMock(dataManager: dataManager!,kwdsDB: mockKwds)
        psVCNib = PastSearchesTableViewController(vmb: pastSearchViewModelMock!)
    }
    
    func testFetchFirstArticles(){
        UIApplication.shared.keyWindow?.rootViewController = psVCNib
        psVCNib?.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "searchcell")
        
        let cell = psVCNib?.tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        XCTAssertEqual(cell?.textLabel!.text, "AAA")
    }
    
    func testFetchSecondArticles(){
        UIApplication.shared.keyWindow?.rootViewController = psVCNib
        psVCNib?.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "searchcell")
        
        let cell = psVCNib?.tableView.cellForRow(at: IndexPath(row: 1, section: 0))
        XCTAssertEqual(cell?.textLabel!.text, "BB")
    }

    func testProcessInternetMessageError(){
        let mess = psVCNib?.processError(-1009)
        XCTAssertEqual(mess?.message, "The Internet appears to be offline")
    }

    func testProcessInternetTitleError(){
        let mess = psVCNib?.processError(-1009)
        XCTAssertEqual(mess?.title, "Connection error")
    }
    
    func testProcessGeneralMessageError(){
        let mess = psVCNib?.processError(-100)
        XCTAssertEqual(mess?.message, "An error has occured")
    }
    
    func testProcessGeneralTitleError(){
        let mess = psVCNib?.processError(-100)
        XCTAssertEqual(mess?.title, "Error")
    }

}
