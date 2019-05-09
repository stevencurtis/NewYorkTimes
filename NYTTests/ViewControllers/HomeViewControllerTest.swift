//
//  HomeViewControllerTest.swift
//  NYTTests
//
//  Created by Steven Curtis on 05/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import XCTest
@testable import NYT

class HomeViewControllerTest: XCTestCase {
    
    var homeVC: HomeViewController?
    var homeVCNib: HomeViewController!
    
    var homeViewModel : HVMock?
    var dataManager : DMMock?
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        dataManager = DataManagerMock()
        homeViewModel = HomeViewModelMock(dataManager: dataManager!)
        
        homeVC = HomeViewController()
        homeVC!.viewModel = homeViewModel!
        
        homeVCNib = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "home") as! HomeViewController)
        homeVCNib.viewModel = homeViewModel!
    }
    
    func testProcessInternetMessageError(){
        let mess = homeVC!.processError(-1009)
        XCTAssertEqual(mess.message, "The Internet appears to be offline")
    }
    
    func testProcessInternetTitleError(){
        let mess = homeVC!.processError(-1009)
        XCTAssertEqual(mess.title, "Connection error")
    }
    
    func testProcessGeneralMessageError(){
        let mess = homeVC!.processError(-100)
        XCTAssertEqual(mess.message, "An error has occured")
    }
    
    func testProcessGeneralTitleError(){
        let mess = homeVC!.processError(-100)
        XCTAssertEqual(mess.title, "Error")
    }
    
    func testPrepBeforeAfterTwoLeft(){
        var mockDV: DetailsViewControllerProtocol = DetailsViewControllerMock()
        homeVC!.prepBeforeAfterArticles(index: 1, articles: [singleDisplayContent, doubleDisplayContent], VC: &mockDV)
        XCTAssertEqual(mockDV.leftContents, singleDisplayContent)
    }
    
    func testPrepBeforeAfterTwoContents(){
        var mockDV: DetailsViewControllerProtocol = DetailsViewControllerMock()
        homeVC!.prepBeforeAfterArticles(index: 1, articles: [singleDisplayContent, doubleDisplayContent], VC: &mockDV)
        XCTAssertEqual(mockDV.contents, doubleDisplayContent)
    }
    
    
    func testPrepBeforeAfterthreeLeft(){
        var mockDV: DetailsViewControllerProtocol = DetailsViewControllerMock()
        homeVC!.prepBeforeAfterArticles(index: 1, articles: [singleDisplayContent, doubleDisplayContent, tripleDisplayContent], VC: &mockDV)
        XCTAssertEqual(mockDV.leftContents, singleDisplayContent)
    }
    
    
    func testPrepBeforeAfterThreeContents(){
        var mockDV: DetailsViewControllerProtocol = DetailsViewControllerMock()
        homeVC!.prepBeforeAfterArticles(index: 1, articles: [singleDisplayContent, doubleDisplayContent, tripleDisplayContent], VC: &mockDV)
        XCTAssertEqual(mockDV.contents, doubleDisplayContent)
    }
    
    func testPrepBeforeAfterThreeRight(){
        homeViewModel!.setNumberMetaData(hits: 3, page: 0)
        var mockDV: DetailsViewControllerProtocol = DetailsViewControllerMock()
        homeVC!.prepBeforeAfterArticles(index: 1, articles: [singleDisplayContent, doubleDisplayContent, tripleDisplayContent], VC: &mockDV)
        XCTAssertEqual(mockDV.rightContents, tripleDisplayContent)
    }

}
