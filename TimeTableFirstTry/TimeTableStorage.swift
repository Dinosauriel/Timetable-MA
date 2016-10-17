//
//  TimeTableStorage.swift
//  Timetable App
//
//  Created by Lukas Boner and Aurel Feer on 25.11.15.
//  Copyright © 2015 Aurel Feer and Lukas Boner. All rights reserved.
//

import Foundation
import WebKit
import CoreData

open class TimeTableStorage {
    let userDefaults = UserDefaults.standard
    
    var tableData:NSArray!
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    func storeTimeTableData(_ data : AnyObject) {
        
        eraseAllData()
        let userData:NSDictionary = (data as! [String:AnyObject])["user"] as! NSDictionary
        let firstname:String = userData["firstname"] as! String
        let lastname:String = userData["lastname"] as! String
        
        userDefaults.set(firstname, forKey: "userfirstname")
        userDefaults.set(lastname, forKey: "userlastname")
        

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
                        var acronymString:String = String(describing: lesson["acronym"]!)
                        var locationString:String = String(describing: lesson["location"]!)
                        
                        if acronymString == "<null>" {
                            acronymString = ""
                        }
                        
                        if locationString == "<null>" {
                            locationString = ""
                        }
                        
                        TimeTableData.createInManagedObjectContext(ManagedObjectContext: moc, ClassName: String(describing: lesson["class"]!), StartTime: String(describing: lesson["start"]!), EndTime: String(describing: lesson["end"]!), Location: locationString, Subject: String(describing: lesson["title"]!), Teacher: acronymString, Day: String(describing: day["date"]!), Event: String(describing: lesson["eventType"]!), ID: Int64(lesson["id"]! as! Int))
                    }
                    //print(lesson)
                    lessonItr += 1
                }
                dayItr += 1
            }
            weeksItr += 1
        }

        //Writing to the file in case of interruption (XCode-Stop)
        do {
            try managedObjectContext?.save()
            print("Saved")
            NotificationCenter.default.post(name: Notification.Name(rawValue: "newData"), object: nil)
        } catch let error {
            print(error)
        }
        userDefaults.set(false, forKey: "isSaving")
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
    
    func getTimeTableDataWithStarttime(_ requestedTime: String) -> [TimeTableData] {
        let fetchRequest = NSFetchRequest(entityName: "TimeTableData")
        fetchRequest.returnsObjectsAsFaults = false
        let predicateForTime = NSPredicate(format: "%K = %@", "startTime", requestedTime)
        fetchRequest.predicate = predicateForTime
        
        if let fetchResults = try! managedObjectContext?.fetch(fetchRequest) as? [TimeTableData] {
            let lessonWithTime = fetchResults
            return lessonWithTime
        } else {
            return []
        }
    }
    
    func getTimeTableDataWithID(_ requestedID :Int) -> [TimeTableData] {
        let fetchRequest = NSFetchRequest(entityName: "TimeTableData")
        fetchRequest.returnsObjectsAsFaults = false
        let predicateForID = NSPredicate(format: "%K = %@","id",NSNumber(value: requestedID as Int))
        fetchRequest.predicate = predicateForID
        
        if let fetchResults = try! managedObjectContext?.fetch(fetchRequest) as? [TimeTableData] {
            let lessonWithID = fetchResults
            return lessonWithID
        } else {
            return []
        }
    }
    
    func getTimeTableDataWithTimeString(_ requestedStartTime :String) -> [TimeTableData] {
        let fetchRequest = NSFetchRequest(entityName: "TimeTableData")
        fetchRequest.returnsObjectsAsFaults = false
        let predicateForID = NSPredicate(format: "%K = %@","startTime",requestedStartTime)
        fetchRequest.predicate = predicateForID
        
        if let fetchResults = try! managedObjectContext?.fetch(fetchRequest) as? [TimeTableData] {
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
            try managedObjectContext?.execute(deleteRequest)
        } catch let error {
            print(error)
        }
        
    }
    
}
