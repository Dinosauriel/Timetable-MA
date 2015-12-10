//
//  TabBarViewController.swift
//  Timetable App
//
//  Created by Aurel Feer on 10.12.15.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
    let darkgreen = UIColor(hue: 0.4778, saturation: 0.73, brightness: 0.46, alpha: 1.0)
        super.viewDidLoad()
        tabBar.tintColor = darkgreen
    }
}