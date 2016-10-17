//
//  FLPageViewController.swift
//  Timetable App
//
//  Created by Aurel Feer and Lukas Boner on 10.12.15.
//  Copyright © 2015 Aurel Feer and Lukas Boner. All rights reserved.
//

import UIKit

class FLPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    //MARK: ARRAYS
    let pageIdentifiers = [
        "FL0ID",
        "FL1ID",
        "FL2ID",
        "FL10ID"]
    
    //MARK: INTEGERS
    var currentPage = 0
    
    //MARK: UIPageViewController
    /**
    Assign dataSource and Delegate
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        defineFirstPage()
        declarePageViewAppearance()
    }
    
    func declarePageViewAppearance() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.lightGray
        appearance.currentPageIndicatorTintColor = UIColor.gray
        appearance.backgroundColor = UIColor.white
    }
    
    /**
    Get first ViewController from storyboard and assigning it to self
    */
    func defineFirstPage() {
        
        let newViewController = storyboard!.instantiateViewController(withIdentifier: pageIdentifiers[currentPage]) as UIViewController
        let startingViewControllers: [UIViewController] = [newViewController]

        self.setViewControllers(startingViewControllers, direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
    }
    
    //MARK: UIPageViewControllerDelegate
    /**
    Only Portrait is supported
    */
    func pageViewControllerSupportedInterfaceOrientations(_ pageViewController: UIPageViewController) -> UIInterfaceOrientationMask {
        return .portrait
    }
    
    /**
    Adapting currentPage upon transition
    */
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        let pendingIdentifier = pendingViewControllers[0].restorationIdentifier
        if pageIdentifiers.contains(pendingIdentifier!) {
            //print("page before: \(currentPage)")
            let pendingPosition = pageIdentifiers.index(of: pendingIdentifier!)
            currentPage = pendingPosition!
            //print("page after: \(currentPage)")
        } else {
            print("WARNING: pending Identifier not in pageIdentifiers!")
        }
    }
    
    //MARK: UIPageViewControllerDataSource
    /**
    Get previous viewController from storyboard based on pageIdentifiers
    */
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if currentPage > 0 {
            let beforeViewController = storyboard?.instantiateViewController(withIdentifier: pageIdentifiers[currentPage - 1])
            return beforeViewController
        } else {
            return nil
        }
    }
    
    /**
    Get next viewController from storyboard based on pageIdentifiers
    */
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if currentPage < (pageIdentifiers.count - 1) {
            let afterViewController = storyboard?.instantiateViewController(withIdentifier: pageIdentifiers[currentPage + 1])
            return afterViewController
        } else {
            return nil
        }
        
    }

    //MARK: FUNCTIONS FOR PAGE INDICATOR
    /**
    Returns number of points in pageIndicator
    */
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pageIdentifiers.count
    }
    
    /**
    Returns starting point of pageIndicator
    */
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
