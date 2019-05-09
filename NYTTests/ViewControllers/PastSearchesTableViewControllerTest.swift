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
        pastSearchViewModelMock = PastSearchVewModelMock(dataManager: dataManager!)
        psVC = PastSearchesTableViewController()
        psVC?.viewModel = pastSearchViewModelMock!
        
        psVCNib = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pastsearch") as! PastSearchesTableViewController)
        psVCNib?.viewModel = pastSearchViewModelMock!
    }
    
    func testFetchFirstArticles(){
        UIApplication.shared.keyWindow?.rootViewController = psVCNib
        let cell = psVCNib?.tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        XCTAssertEqual(cell?.textLabel!.text, "Election")
    }
    
    func testFetchSecondArticles(){
        UIApplication.shared.keyWindow?.rootViewController = psVCNib
        let cell = psVCNib?.tableView.cellForRow(at: IndexPath(row: 1, section: 0))
        XCTAssertEqual(cell?.textLabel!.text, "Oo")
    }

    func testProcessInternetMessageError(){
        let mess = psVC!.processError(-1009)
        XCTAssertEqual(mess.message, "The Internet appears to be offline")
    }
    
    func testProcessInternetTitleError(){
        let mess = psVC!.processError(-1009)
        XCTAssertEqual(mess.title, "Connection error")
    }
    
    func testProcessGeneralMessageError(){
        let mess = psVC!.processError(-100)
        XCTAssertEqual(mess.message, "An error has occured")
    }
    
    func testProcessGeneralTitleError(){
        let mess = psVC!.processError(-100)
        XCTAssertEqual(mess.title, "Error")
    }

}
