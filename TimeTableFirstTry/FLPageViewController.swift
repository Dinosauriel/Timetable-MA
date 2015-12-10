//
//  FLPageViewController.swift
//  Timetable App
//
//  Created by Aurel Feer on 10.12.15.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import UIKit

class FLPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    let pageIdentifiers = [
        "FL0ID",
        "FL1ID",
        "LoginVCID"]
    
    var currentPage = 0
    
    var pageViewController: UIPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defineFirstPage()
        declarePageViewAppearance()
        pageViewController?.dataSource = self
    }
    
    func declarePageViewAppearance() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.lightGrayColor()
        appearance.currentPageIndicatorTintColor = UIColor.grayColor()
        appearance.backgroundColor = UIColor.whiteColor()
    }
    
    func defineFirstPage() {
        let firstViewController = storyboard!.instantiateViewControllerWithIdentifier(pageIdentifiers[currentPage]) as UIViewController
        let startingViewControllers = [firstViewController]
        self.setViewControllers(startingViewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        print("--")
        
        if currentPage > 0 {
            let pageItemViewController = storyboard?.instantiateViewControllerWithIdentifier(pageIdentifiers[currentPage - 1])
            --currentPage
            return pageItemViewController
        }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        print("++")
        
        if currentPage < pageIdentifiers.count {
            let pageItemViewController = storyboard?.instantiateViewControllerWithIdentifier(pageIdentifiers[currentPage + 1])
            ++currentPage
            
            return pageItemViewController
        }
        return nil
    }

    //MARK: FUNCTIONS FOR PAGE INDICATOR
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pageIdentifiers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}
