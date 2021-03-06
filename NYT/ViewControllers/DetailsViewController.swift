//
//  DetailViewController.swift
//  NYT
//
//  Created by Steven Curtis on 04/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import UIKit

public protocol DetailsViewControllerProtocol {
    var contents : DisplayContent? { get set }
    var leftContents : DisplayContent? { get set }
    var rightContents : DisplayContent? { get set }
}

final class DetailsViewController: UIViewController, UIPageViewControllerDataSource {
    
    var contents : DisplayContent?
    var leftContents : DisplayContent?
    var rightContents : DisplayContent?
    var pages = [UIViewController]()

    fileprivate var pageVC: UIPageViewController!
    fileprivate var leftVC: DisplayDetailsViewController!
    fileprivate var rightVC: DisplayDetailsViewController!
    fileprivate var midVC: DisplayDetailsViewController!
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else {return nil}
        if currentIndex == 0 || (currentIndex == 1 && leftContents == nil)  {return nil}
        let previousIndex = abs((currentIndex - 1) % pages.count)
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else {return nil}
        if currentIndex == 2 || (currentIndex == 2 && rightContents == nil) {return nil}
        let nextIndex = abs((currentIndex + 1) % pages.count)
        return pages[nextIndex]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let storyboard = storyboard else {return}
        
        pageVC = (storyboard.instantiateViewController(withIdentifier: "DetailsPageViewController") as? UIPageViewController)
        leftVC = (storyboard.instantiateViewController(withIdentifier: "DisplayDetailsViewController") as? DisplayDetailsViewController)
        rightVC = (storyboard.instantiateViewController(withIdentifier: "DisplayDetailsViewController") as? DisplayDetailsViewController)
        midVC = (storyboard.instantiateViewController(withIdentifier: "DisplayDetailsViewController") as? DisplayDetailsViewController)
        
        midVC.contents = contents
        leftVC.contents = leftContents
        rightVC.contents = rightContents
        
        pages.insert(leftVC, at: 0)
        pages.insert(midVC, at: 1)
        pages.insert(rightVC, at: 2)
        
        pageVC.setViewControllers([pages[1]], direction: .forward, animated: true, completion: nil)
        pageVC.dataSource = self
        view.addSubview(pageVC.view)
        addChild(pageVC)
        pageVC.didMove(toParent: self)
        
    }
}

extension DetailsViewController: DetailsViewControllerProtocol {}
