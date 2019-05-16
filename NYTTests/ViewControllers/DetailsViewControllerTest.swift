//
//  DetailsViewControllerTest.swift
//  NYTTests
//
//  Created by Steven Curtis on 08/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import XCTest
@testable import NYT


class DetailsViewControllerTest: XCTestCase {

    var detailsVC: DetailsViewController?

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        detailsVC = DetailsViewController()
    }
    
    func testInitialNilPagesViewModel() {
        let mockPG = UIPageViewControllerMock()
        let displayVC = DisplayDetailsViewController()
        let ret = detailsVC?.pageViewController(mockPG, viewControllerAfter: displayVC)
        XCTAssertEqual(ret, nil)
    }

    func testInitialBeforeRightDetailsViewModel() {
        let mockPG = UIPageViewControllerMock()
        let displayVC = DisplayDetailsViewController()

        
        let leftVC =  DisplayDetailsViewController()
        let rightVC = displayVC
        let midVC = DisplayDetailsViewController()
        
        var pages = [UIViewController]()
        pages.insert(leftVC, at: 0)
        pages.insert(midVC, at: 1)
        pages.insert(rightVC, at: 2)
        
        detailsVC!.pages = pages
        
        let ret = detailsVC?.pageViewController(mockPG, viewControllerBefore: displayVC)
        XCTAssertEqual(ret, midVC)
    }
    
    func testInitialBeforeIndexOneDetailsViewModel() {
        let mockPG = UIPageViewControllerMock()
        let displayVC = DisplayDetailsViewController()
        
        let leftVC =  displayVC
        let rightVC = DisplayDetailsViewController()
        let midVC = DisplayDetailsViewController()
        
        var pages = [UIViewController]()
        pages.insert(leftVC, at: 0)
        pages.insert(midVC, at: 1)
        pages.insert(rightVC, at: 2)
        
        detailsVC!.pages = pages
        
        let ret = detailsVC?.pageViewController(mockPG, viewControllerBefore: displayVC)
        XCTAssertEqual(ret, nil)
    }
    
    func testBeforeMidDetailsViewModel() {
        let mockPG = UIPageViewControllerMock()
        let displayVC = DisplayDetailsViewController()
        
        let leftVC =  DisplayDetailsViewController()
        let rightVC = DisplayDetailsViewController()
        let midVC = displayVC
        
        var pages = [UIViewController]()
        pages.insert(leftVC, at: 0)
        pages.insert(midVC, at: 1)
        pages.insert(rightVC, at: 2)
        
        detailsVC!.pages = pages
        
        let ret = detailsVC?.pageViewController(mockPG, viewControllerBefore: rightVC)
        XCTAssertEqual(ret, midVC)
    }


    
    func testInitialAfterRightDetailsViewModel() {
        let mockPG = UIPageViewControllerMock()
        let displayVC = DisplayDetailsViewController()
        
        let leftVC =  DisplayDetailsViewController()
        let rightVC = displayVC
        let midVC = DisplayDetailsViewController()
        
        var pages = [UIViewController]()
        pages.insert(leftVC, at: 0)
        pages.insert(midVC, at: 1)
        pages.insert(rightVC, at: 2)
        
        detailsVC!.pages = pages
        
        let ret = detailsVC?.pageViewController(mockPG, viewControllerAfter: rightVC)
        XCTAssertEqual(ret, nil)
    }
    
    
    func testInitialAfterMidDetailsViewModel() {
        let mockPG = UIPageViewControllerMock()
        let displayVC = DisplayDetailsViewController()
        
        let leftVC =  DisplayDetailsViewController()
        let rightVC = DisplayDetailsViewController()
        let midVC = displayVC
        
        var pages = [UIViewController]()
        pages.insert(leftVC, at: 0)
        pages.insert(midVC, at: 1)
        pages.insert(rightVC, at: 2)
        
        detailsVC!.pages = pages
        
        let ret = detailsVC?.pageViewController(mockPG, viewControllerAfter: midVC)
        XCTAssertEqual(ret, rightVC)
    }

    
    
}
