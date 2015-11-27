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
    
    func storeTimeTableData(data : AnyObject) {
        
        eraseAllData()
        
        var i = 0
        let body = data["body"] as! NSArray
        let endI = body.accessibilityElementCount()
        var lesson = [String : String]()
        
        while i != endI {
            lesson = try body[i] as! NSDictionary as! [String : String]
            if let moc = self.managedObjectContext {
                TimeTableData.createInManagedObjectContext(ManagedObjectContext: moc, ClassName: lesson["Class"]!, StartTime: lesson["StartTime"]!, EndTime: lesson["EndTime"]!, Location: lesson["Location"]!, Subject: lesson["Subject"]!, Teacher: lesson["Teacher"]!, Day: lesson["Day"]!)
            }
            i++
        }
        
        //Saves the token to the local storage for later use

        //Writing to the file in case of interruption (XCode-Stop)
        do {
            try managedObjectContext?.save()
            print("Saved")
        } catch let error {
            print(error)
        }
    }
    
    func getTimeTableData() -> NSArray {
        let fetchRequest = NSFetchRequest(entityName: "TimeTableData")
        
        if let fetchResults = try! managedObjectContext?.executeFetchRequest(fetchRequest) as? [TimeTableData] {
            if fetchResults.count != 0 {
                if fetchResults.count == 1 {
                    tableData = fetchResults
                    return tableData
                } else {
                    return []
                }
            } else {
                print("No token")
                return []
            }
        } else {
            return []
        }
    }
    
    func eraseAllData() {
        let fetchDeleteRequest = NSFetchRequest(entityName: "TimeTableData")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchDeleteRequest)
        
        do {
            try managedObjectContext?.executeRequest(deleteRequest)
        } catch let error {
            print(error)
        }
        
    }
    
}
