//
//  FLPageViewController.swift
//  Timetable App
//
//  Created by Aurel Feer on 10.12.15.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import UIKit

class FLPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    let pageIdentifiers = [
        "FL0ID",
        "FL1ID"]
    
    var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        defineFirstPage()
        declarePageViewAppearance()
        //pageViewController?.dataSource = self
    }
    
    func declarePageViewAppearance() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.lightGrayColor()
        appearance.currentPageIndicatorTintColor = UIColor.grayColor()
        appearance.backgroundColor = UIColor.whiteColor()
    }
    
    func defineFirstPage() {
        
        let newViewController = storyboard!.instantiateViewControllerWithIdentifier(pageIdentifiers[currentPage]) as UIViewController
        let startingViewControllers: [UIViewController] = [newViewController]

        self.setViewControllers(startingViewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
    }
    
    func disablePageViewController() {

    }
    
    //MARK: UIPageViewControllerDelegate
    func pageViewControllerSupportedInterfaceOrientations(pageViewController: UIPageViewController) -> UIInterfaceOrientationMask {
        return .Portrait
    }
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        let pendingIdentifier = pendingViewControllers[0].restorationIdentifier
        if pageIdentifiers.contains(pendingIdentifier!) {
            print("page before: \(currentPage)")
            let pendingPosition = pageIdentifiers.indexOf(pendingIdentifier!)
            currentPage = pendingPosition!
            print("page after: \(currentPage)")

        } else {
            
            print("WARNING: pending Identifier not in pageIdentifiers!")
        }
    }
    
    //MARK: UIPageViewControllerDataSource
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if currentPage > 0 {
            let beforeViewController = storyboard?.instantiateViewControllerWithIdentifier(pageIdentifiers[currentPage - 1])
            return beforeViewController
        } else {
            return nil
        }
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if currentPage < (pageIdentifiers.count - 1) {
            let afterViewController = storyboard?.instantiateViewControllerWithIdentifier(pageIdentifiers[currentPage + 1])
            return afterViewController
        } else {
            return nil
        }
        
    }

    //MARK: FUNCTIONS FOR PAGE INDICATOR
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pageIdentifiers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}
