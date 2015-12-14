//
//  TTLandscapeCollectionViewLayout.swift
//  Timetable App
//
//  Created by Aurel Feer on 13.12.15.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import UIKit

class TTLandscapeCollectionViewLayout: TTCollectionViewLayout {
    override func widthForItemWithColumnIndex(columnIndex: Int) -> CGFloat {
        
        let timeColumnWidth: CGFloat = getTimeColumnWidth()
        if columnIndex != 0 {
            let width: CGFloat
            let screenSize: CGRect = UIScreen.mainScreen().bounds
            if UIApplication.sharedApplication().statusBarOrientation == .Portrait {
                width = ((screenSize.height - timeColumnWidth) / 5) - marginBetweenRows
            } else {
                width = ((screenSize.width - timeColumnWidth) / 5) - marginBetweenRows
            }
            return width
            
        } else {
            
            return timeColumnWidth
        }
    }

    
}