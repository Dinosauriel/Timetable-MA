//
//  DeviceSupport.swift
//  Timetable App
//
//  Created by Aurel Feer and Lukas Boner on 19.12.15.
//  Copyright © 2015 Aurel Feer and Lukas Boner. All rights reserved.
//

import UIKit

class DeviceSupport {
    
    /**
    Returns heigth of Display regardless of the current orientation
    */
    func getAbsoluteDisplayHeight() -> CGFloat {
        let orientation = UIApplication.shared.statusBarOrientation

        if orientation == .portrait || orientation == .portraitUpsideDown {
            return UIScreen.main.bounds.height
        } else {
            return UIScreen.main.bounds.width
        }
        
    }
    
    /**
    Returns heigth of Display regardless of the current orientation
    */
    func getAbsoluteDisplayWidth() -> CGFloat {
        let orientation = UIApplication.shared.statusBarOrientation
        
        if orientation == .portrait || orientation == .portraitUpsideDown {
            return UIScreen.main.bounds.width
        } else {
            return UIScreen.main.bounds.height
        }

    }
}
