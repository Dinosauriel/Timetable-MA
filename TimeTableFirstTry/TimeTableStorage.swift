//
//  TimeTableStorage.swift
//  TimeTableFirstTry
//
//  Created by Lukas Boner on 25.11.15.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import Foundation
import WebKit
import CoreData

class TimeTableStorage {
    
    var tableData:NSArray!
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    func storeTimeTableData(data : NSArray) {
        tableData = data
    }
    
    func getTimeTableData() -> NSArray {
        let fetchRequest = NSFetchRequest(entityName: TimeTableData)
        
        if let fetchResults = try managedObjectContext?.executeFetchRequest(fetchRequest) as? 
        
        return tableData
    }
    
    func eraseAllData() {
        let fetchDeleteRequest = NSFetchRequest(entityName: "TimeTableData")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchDeleteRequest)
        
        do {
            try managedObjectContext?.executeRequest(deleteRequest)
        } catch let error as NSError {
            print(error)
        }
        
    }
    
}
