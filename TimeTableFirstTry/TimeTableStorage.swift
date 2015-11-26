//
//  TimeTableStorage.swift
//  TimeTableFirstTry
//
//  Created by Lukas Boner on 25.11.15.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import Foundation

class TimeTableStorage {
    
    var tableData:NSArray!
    
    func storeTimeTableData(data : NSArray) {
        tableData = data
    }
    
    func getTimeTableData() -> NSArray {
        return tableData
    }
    
}
