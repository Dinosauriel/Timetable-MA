//
//  GetLesson.swift
//  Timetable App
//
//  Created by Aurel Feer on 15.01.16.
//  Copyright © 2016 Aurel Feer. All rights reserved.
//

import Foundation

class GetLesson {
    let time = TimetableTime()
    //let calendar = NSCalendar.currentCalendar()
    //let formatter = NSDateFormatter()
    
    let targetWeek = 1
    let timetableIdentifier = "timetable"
    let lessonsIdentifier = "lessons"
    
    let timeZoneAppendix = "+01:00"
    let dateTimeSeparator = "T"
    
    let timeStringArray: [String] = ["07:45:00", "08:35:00", "09:25:00", "10:20:00", "11:10:00", "12:00:00", "12:45:00", "13:35:00", "14:25:00", "15:15:00", "16:05:00", "16:50:00","17:35:00"]
    let dayStringArray = Day().generateDayArray(.long, forUI: false)
    
    let numberOfNextLessons = 3
    
    var nextLessons: [[String: AnyObject]] = []
    
    func setUpNextLessonsWithTimetable(data: NSMutableDictionary) {
        let lessonPos: [Int] = time.getCurrentLessonCoordinates()
        
        let timeString = timeStringArray[lessonPos[1]]
        let dayString = dayStringArray[lessonPos[0] - 2]
        
        let dateString = dayString + dateTimeSeparator + timeString + timeZoneAppendix
        print(dayStringArray)
        print(timeString)
        print(dayString)
        
        let dayPredicate = NSPredicate(format: "%K = %@","date",dayString)
        
        
        let timetable: NSArray = data[timetableIdentifier] as! NSArray
        print("----------------timetable---------------------------------------")
        print(timetable)
        var oneDay: NSMutableDictionary!
        
        for week in timetable {
        
            let filteredWeekForDay = week.filteredArrayUsingPredicate(dayPredicate)
            
            if filteredWeekForDay.count != 0 {
                oneDay = filteredWeekForDay[0] as! NSMutableDictionary
                print("----------------oneDay---------------------------------------")
                print(oneDay)
                
                break
            }
        }
        
        let allLessonsInOneDay: [[String: AnyObject]] = oneDay[lessonsIdentifier] as! [[String: AnyObject]]
        print("----------------allLessonsInOneDay---------------------------------------")
        print(allLessonsInOneDay)
        
        //for lessonCorrection in 0 ..< numberOfNextLessons {
            self.nextLessons.append(allLessonsInOneDay[3])// as [String: AnyObject])
            print("nextLessons: \(self.nextLessons)")
        //}
        
    }
}