//
//  TTLandscapeCollectionViewLayout.swift
//  Timetable App
//
//  Created by Aurel Feer on 13.12.15.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import UIKit

class TTLandscapeCollectionViewLayout: TTCollectionViewLayout {
    
    /**
    overriding width function for week layout
    */
    override func widthForItemWithColumn(column: Int) -> CGFloat {
        
        let timeColumnWidth: CGFloat = getTimeColumnWidth()
        numberOfDaysOnScreen = 5
        
        if column != 0 {
            let width: CGFloat
            let screenSize: CGRect = UIScreen.mainScreen().bounds
            if UIApplication.sharedApplication().statusBarOrientation == .Portrait {
                width = ((screenSize.height - timeColumnWidth) / numberOfDaysOnScreen) - marginBetweenRows
            } else {
                width = ((screenSize.width - timeColumnWidth) / numberOfDaysOnScreen) - marginBetweenRows
            }
            return width
            
        } else {
            
            return timeColumnWidth
        }
    }
    
    /**
    overriding height function for week layout
    */
    override func heightForItemWithSection(section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat(30)
        } else {
            return CGFloat(40)
        }
    }
    
}
