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

public class TimeTableStorage {
    
    var tableData:NSArray!
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    func storeTimeTableData(data : AnyObject) {
        print("a")
        eraseAllData()
        print("c")
        var i = 0
        let body = data["body"] as! NSArray
        let endI = body.count
        var lesson = [String : String]()
        
        while i != endI {
            lesson = body[i] as! NSDictionary as! [String : String]
            if let moc = self.managedObjectContext {
                TimeTableData.createInManagedObjectContext(ManagedObjectContext: moc, ClassName: String(lesson["Class"]!), StartTime: String(lesson["StartTime"]!), EndTime: String(lesson["EndTime"]!), Location: String(lesson["Location"]!), Subject: String(lesson["Subject"]!), Teacher: String(lesson["Teacher"]!), Day: String(lesson["Day"]!))
            }
            ++i
            //print(lesson)
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
    
    func getTimeTableData() -> [TimeTableData] {
        let fetchRequest = NSFetchRequest(entityName: "TimeTableData")
        if let fetchResults = try! managedObjectContext?.executeFetchRequest(fetchRequest) as? [TimeTableData] {
            tableData = fetchResults
            return tableData as! [TimeTableData]
        } else {
            print("failed")
            return []
        }
    }
    
    func getTimeTableDataWithDayInt(day:String) -> [TimeTableData] {
        let tempArray = getTimeTableData()
        var finalArray = [TimeTableData]()
        for tempLesson in tempArray {
            if tempLesson.day == day {
                finalArray.append(tempLesson)
            }
        }
        return finalArray
    }
    
    func eraseAllData() -> Void {
        let fetchDeleteRequest = NSFetchRequest(entityName: "TimeTableData")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchDeleteRequest)
        
        do {
            try managedObjectContext?.executeRequest(deleteRequest)
        } catch let error {
            print(error)
        }
        print("b")
        
    }
    
}
