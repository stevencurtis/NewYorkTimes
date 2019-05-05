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
    
    var homeVC: HomeViewController!
    var homeVCNib: HomeViewController!
    
    let dc = DisplayContent(title: "test", abstract: "abs", thumbnailImageString: "tbstr", date: "data", image: "imgStr")
    let dm = DisplayContentMetaData(hits: 100, page: 1)

    override func setUp() {
        homeVC = HomeViewController(dataManager: MockDataManager() )
    }
    
    func testProcessInternetError(){
        homeVCNib =  (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "home") as! HomeViewController)
        UIApplication.shared.keyWindow?.rootViewController = homeVCNib
        homeVCNib.processError(-1009)
        XCTAssertTrue(homeVCNib.presentedViewController is UIAlertController)
        XCTAssertEqual(homeVCNib.presentedViewController?.title, "Connection error")
    }
    
    func testProcessGeneralError(){
        homeVCNib =  (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "home") as! HomeViewController)
        UIApplication.shared.keyWindow?.rootViewController = homeVCNib
        homeVCNib.processError(-100)
        XCTAssertTrue(homeVCNib.presentedViewController is UIAlertController)
        XCTAssertEqual(homeVCNib.presentedViewController?.title, "Error")
    }

    
    func testDisplayContent(){
        homeVCNib =  (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "home") as! HomeViewController)
        UIApplication.shared.keyWindow?.rootViewController = homeVCNib
        homeVCNib.displayContent( [dc], dm, false)
        XCTAssertEqual(homeVCNib.articles.count, 1)
        XCTAssertEqual(homeVCNib.articles.first?.title, "test")
        XCTAssertEqual(homeVCNib.articles.first?.abstract, "abs")
        XCTAssertEqual(homeVCNib.articles.first?.thumbnailImageString, "tbstr")
        XCTAssertEqual(homeVCNib.articles.first?.date, "data")
        XCTAssertEqual(homeVCNib.articles.first?.image, "imgStr")
    }
    
    func testDisplayFullMockedContent(){
        homeVC.fetchArticle(sender: nil) { (result: Result<(content: [DisplayContent], metadata: DisplayContentMetaData), Error>, refresh) in
            
            switch result {
            case .failure(let error):
                XCTAssertNil(error)
            case .success(let res):
                XCTAssertEqual(res.content.count, 1)
                XCTAssertEqual(res.content.first!.abstract, "testAbstract")

            }

        }
        


    }


}
