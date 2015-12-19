//
//  CheckForSpecialLessons.swift
//  Timetable App
//
//  Created by Lukas Boner on 19.12.15.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import Foundation

class CheckForSpecialLessons {
    
    func checkForSpecialLessons(dataDict:NSDictionary) {
        for week in dataDict["timetable"] as! [NSArray] {
            for day:NSDictionary in week as! [NSDictionary] {
                let lessons:NSArray = day["lessons"] as! NSArray
                for lessonToCheck:NSDictionary in lessons as! [NSDictionary] {
                    if lessonToCheck["eventType"] as! String != "lesson" {
                        for lesson:NSDictionary in lessons as! [NSDictionary] {
                            if lesson["eventType"] as! String != "lesson" {
                                let dateFormatter:NSDateFormatter = NSDateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                                var startStringToCheck:String = lessonToCheck["start"]! as! String
                                startStringToCheck = startStringToCheck.stringByReplacingOccurrencesOfString("T", withString: " ")
                                startStringToCheck = startStringToCheck.stringByReplacingOccurrencesOfString("+", withString: " +")
                                let startDateToCheck = dateFormatter.dateFromString(startStringToCheck)
                                
                                var endStringToCheck:String = lessonToCheck["start"]! as! String
                                endStringToCheck = endStringToCheck.stringByReplacingOccurrencesOfString("T", withString: " ")
                                endStringToCheck = endStringToCheck.stringByReplacingOccurrencesOfString("+", withString: " +")
                                let endDateToCheck = dateFormatter.dateFromString(endStringToCheck)
                                
                                var startString:String = lesson["start"]! as! String
                                startString = startString.stringByReplacingOccurrencesOfString("T", withString: " ")
                                startString = startString.stringByReplacingOccurrencesOfString("+", withString: " +")
                                let startDate = dateFormatter.dateFromString(startString)
                                
                                var endString:String = lesson["start"]! as! String
                                endString = endString.stringByReplacingOccurrencesOfString("T", withString: " ")
                                endString = endString.stringByReplacingOccurrencesOfString("+", withString: " +")
                                let endDate = dateFormatter.dateFromString(endString)
                                
                                if lessonToCheck["id"] as! Int != lesson["id"] as! Int && lessonToCheck["eventType"] as! String != "cancel" {
                                    if startDateToCheck <= startDate || endDateToCheck >= endDate {
                                        print("Lesson ")
                                        print(lessonToCheck)
                                        print(" overrides ")
                                        print(lesson)
                                    }
                                }
                                
                            }
                        }
                    } else {
                        
                    }
                }
            }
        }
        
    }
    
}