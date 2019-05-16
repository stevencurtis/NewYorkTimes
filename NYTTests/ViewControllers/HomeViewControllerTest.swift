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
    
    var homeVCNib: HomeViewController!
    var homeViewModel : HVMock?
    var dataManager : DMMock?
    
    let twoArticles = [singleDisplayContent, doubleDisplayContent]
    let threeArticles = [singleDisplayContent, doubleDisplayContent, tripleDisplayContent]
    
    override func setUp() {
        dataManager = DataManagerMock()
    }
    
    func setupContent(with displayContent: [DisplayContent]? = nil){
        if let dc = displayContent {
            dataManager?.setArticles(displayContent: dc)
        }
        let homeViewModelBuilderMock = HomeViewModelBuilderMock(dataManager: dataManager)
        homeVCNib = HomeViewController(hvm: homeViewModelBuilderMock)
    }
    
    func testPrepBeforeAfterThreeRight(){
        setupContent(with: threeArticles)
        var mockDV: DetailsViewControllerProtocol = DetailsViewControllerMock()
        
        homeVCNib!.prepBeforeAfterArticles(index: 1, articles: threeArticles, VC: &mockDV)
        XCTAssertEqual(mockDV.rightContents, tripleDisplayContent)
    }
    
    func testPrepBeforeAfterTwoLeft(){
        setupContent(with: twoArticles)
        var mockDV: DetailsViewControllerProtocol = DetailsViewControllerMock()
        
        homeVCNib!.prepBeforeAfterArticles(index: 1, articles: twoArticles, VC: &mockDV)
        XCTAssertEqual(mockDV.leftContents, singleDisplayContent)
    }
    
    func testPrepBeforeAfterTwoContents(){
        setupContent(with: twoArticles)

        var mockDV: DetailsViewControllerProtocol = DetailsViewControllerMock()
        homeVCNib!.prepBeforeAfterArticles(index: 1, articles: twoArticles, VC: &mockDV)
        XCTAssertEqual(mockDV.contents, doubleDisplayContent)
    }
    
    func testPrepBeforeAfterthreeLeft(){
        setupContent(with: threeArticles)

        var mockDV: DetailsViewControllerProtocol = DetailsViewControllerMock()
        homeVCNib!.prepBeforeAfterArticles(index: 1, articles: threeArticles, VC: &mockDV)
        XCTAssertEqual(mockDV.leftContents, singleDisplayContent)
    }
    
    func testPrepBeforeAfterThreeContents(){
        setupContent(with: threeArticles)

        var mockDV: DetailsViewControllerProtocol = DetailsViewControllerMock()
        homeVCNib!.prepBeforeAfterArticles(index: 1, articles: threeArticles, VC: &mockDV)
        XCTAssertEqual(mockDV.contents, doubleDisplayContent)
    }
    
    func testProcessInternetMessageError(){
        setupContent()
        
        let mess = homeVCNib?.processError(-1009)
        XCTAssertEqual(mess?.message, "The Internet appears to be offline")
    }
    
    func testProcessInternetTitleError(){
        setupContent()

        let mess = homeVCNib?.processError(-1009)
        XCTAssertEqual(mess?.title, "Connection error")
    }
    
    func testProcessGeneralMessageError(){
        setupContent()

        let mess = homeVCNib?.processError(-100)
        XCTAssertEqual(mess?.message, "An error has occured")
    }
    
    func testProcessGeneralTitleError(){
        setupContent()

        let mess = homeVCNib?.processError(-100)
        XCTAssertEqual(mess?.title, "Error")
    }

}
