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
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    var tableData:NSArray!
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    func storeTimeTableData(data : AnyObject) {
        
        eraseAllData()
        let userData:NSDictionary = (data as! [String:AnyObject])["user"] as! NSDictionary
        let firstname:String = userData["firstname"] as! String
        let lastname:String = userData["lastname"] as! String
        
        userDefaults.setObject(firstname, forKey: "userfirstname")
        userDefaults.setObject(lastname, forKey: "userlastname")
        

        let weeks:NSArray = (data as! [String:AnyObject])["timetable"] as! NSArray
        let weeksCount = weeks.count
        var weeksItr = 0
        
        while weeksItr != weeksCount {
            let week:NSArray = weeks[weeksItr] as! NSArray
            let dayCount = week.count
            var dayItr = 0
            
            while dayItr != dayCount {
                let day:NSDictionary = week[dayItr] as! NSDictionary
                let lessons:NSArray = day["lessons"] as! NSArray
                let lessonCount = lessons.count
                var lessonItr = 0
                
                while lessonItr != lessonCount {
                    let lesson:NSDictionary = lessons[lessonItr] as! NSDictionary
                    if let moc = self.managedObjectContext {
                        var acronymString:String = String(lesson["acronym"]!)
                        var locationString:String = String(lesson["location"]!)
                        
                        if acronymString == "<null>" {
                            acronymString = ""
                        }
                        
                        if locationString == "<null>" {
                            locationString = ""
                        }
                        
                        TimeTableData.createInManagedObjectContext(ManagedObjectContext: moc, ClassName: String(lesson["class"]!), StartTime: String(lesson["start"]!), EndTime: String(lesson["end"]!), Location: locationString, Subject: String(lesson["title"]!), Teacher: acronymString, Day: String(day["date"]!), Event: String(lesson["eventType"]!), ID: Int64(lesson["id"]! as! Int))
                    }
                    //print(lesson)
                    ++lessonItr
                }
                ++dayItr
            }
            ++weeksItr
        }

        //Writing to the file in case of interruption (XCode-Stop)
        do {
            try managedObjectContext?.save()
            print("Saved")
            NSNotificationCenter.defaultCenter().postNotificationName("newData", object: nil)
        } catch let error {
            print(error)
        }
        userDefaults.setBool(false, forKey: "isSaving")
    }
    
    /*func getTimeTableDataWithDay(requestedDay: String) -> [TimeTableData]{
        let fetchRequest = NSFetchRequest(entityName: "TimeTableData")
        fetchRequest.returnsObjectsAsFaults = false
        let predicateForDay = NSPredicate(format: "%K = %@", "day", requestedDay)
        fetchRequest.predicate = predicateForDay
        
        if let fetchResults = try! managedObjectContext?.executeFetchRequest(fetchRequest) as? [TimeTableData] {
            let lessonsInDay = fetchResults
            return lessonsInDay
        } else {
            return []
        }
    }*/
    
    func getTimeTableDataWithStarttime(requestedTime: String) -> [TimeTableData] {
        let fetchRequest = NSFetchRequest(entityName: "TimeTableData")
        fetchRequest.returnsObjectsAsFaults = false
        let predicateForTime = NSPredicate(format: "%K = %@", "startTime", requestedTime)
        fetchRequest.predicate = predicateForTime
        
        if let fetchResults = try! managedObjectContext?.executeFetchRequest(fetchRequest) as? [TimeTableData] {
            let lessonWithTime = fetchResults
            return lessonWithTime
        } else {
            return []
        }
    }
    
    func getTimeTableDataWithID(requestedID :Int) -> [TimeTableData] {
        let fetchRequest = NSFetchRequest(entityName: "TimeTableData")
        fetchRequest.returnsObjectsAsFaults = false
        let predicateForID = NSPredicate(format: "%K = %@","id",NSNumber(long: requestedID))
        fetchRequest.predicate = predicateForID
        
        if let fetchResults = try! managedObjectContext?.executeFetchRequest(fetchRequest) as? [TimeTableData] {
            let lessonWithID = fetchResults
            return lessonWithID
        } else {
            return []
        }
    }
    
    /*func getTimeTableData() -> NSArray {
        let fetchRequest = NSFetchRequest(entityName: "TimeTableData")
        fetchRequest.returnsObjectsAsFaults = false
        if let fetchResults = try! managedObjectContext?.executeFetchRequest(fetchRequest) as? [TimeTableData] {
            tableData = fetchResults
            return tableData
        } else {
            print("getTimeTableData: Fech Request failed")
            return []
        }
    }*/

    
    func eraseAllData() -> Void {
        let fetchDeleteRequest = NSFetchRequest(entityName: "TimeTableData")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchDeleteRequest)
        
        do {
            try managedObjectContext?.executeRequest(deleteRequest)
        } catch let error {
            print(error)
        }
        
    }
    
}
