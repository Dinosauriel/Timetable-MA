//
//  TabBarViewController.swift
//  Timetable App
//
//  Created by Aurel Feer and Lukas Boner on 10.12.15.
//  Copyright © 2015 Aurel Feer and Lukas Boner. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    /**
    Apply tint color to active TabBarItems
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        let darkgreen = UIColor(hue: 0.4778, saturation: 0.73, brightness: 0.46, alpha: 1.0)
        tabBar.tintColor = darkgreen
    }
}