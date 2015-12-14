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
        /*print("a")
        eraseAllData()
        print("c")
        var i = 0
        let body = data["body"] as! NSArray
        let endI = body.count
        var lesson = [String : String]()
        
        while i != endI {
            lesson = body[i] as! NSDictionary as! [String : String]
            if let moc = self.managedObjectContext {
                TimeTableData.createInManagedObjectContext(ManagedObjectContext: moc, ClassName: String(lesson["class"]!), StartTime: String(lesson["start"]!), EndTime: String(lesson["end"]!), Location: String(lesson["Location"]!), Subject: String(lesson["Subject"]!), Teacher: String(lesson["acronym"]!), Day: String(lesson["Day"]!), Event: String(lesson["event"]))
            }
            ++i
            //print(lesson)
        }*/
        
        eraseAllData()
        
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
                        TimeTableData.createInManagedObjectContext(ManagedObjectContext: moc, ClassName: String(lesson["class"]!), StartTime: String(lesson["start"]!), EndTime: String(lesson["end"]!), Location: String(lesson["location"]!), Subject: String(lesson["title"]!), Teacher: String(lesson["acronym"]!), Day: String(day["date"]!), Event: String(lesson["eventType"]!))
                    }
                    print(lesson)
                    ++lessonItr
                }
                ++dayItr
            }
            ++weeksItr
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
        print("Fetching Data")
        if let fetchResults = try! managedObjectContext?.executeFetchRequest(fetchRequest) as? [TimeTableData] {
            tableData = fetchResults
            return tableData as! [TimeTableData]
        } else {
            print("failed")
            return []
        }
    }
    
    func getTimeTableDataWithDayString(day:String) -> [TimeTableData] {
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
