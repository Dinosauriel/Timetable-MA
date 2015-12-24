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
        
        //Only three days in landscape mode of iPhone4s
        if sup.getAbsoluteDisplayHeight() > 480 {
            numberOfDaysOnScreen = 5
        } else {
            numberOfDaysOnScreen = 3
        }
        
        //Calculate width using numberOfDaysOnScreen
        if column != 0 {
            let width: CGFloat
            width = ((sup.getAbsoluteDisplayHeight() - timeColumnWidth) / numberOfDaysOnScreen) - marginBetweenRows
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
