//
//  TimetableTime.swift
//  TimeTableFirstTry
//
//  Created by Aurel Feer on 02.11.15.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import Foundation

class TimetableTime {
    let date = NSDate()
    let calendar = NSCalendar.currentCalendar()
    let formatter = NSDateFormatter()
    
    let startHours = [7, 8, 9, 10, 11, 12, 12, 13, 14, 15, 16, 16, 17]
    let startMinutes = [45, 35, 25, 20, 10, 00, 45, 35, 25, 15, 05, 50, 35]
    
    let endHours = [8, 9, 10, 11, 11, 12, 13, 14, 15, 15, 16, 17, 18]
    let endMinutes = [25, 15, 05, 00, 50, 40, 25, 15, 05, 55, 45, 30, 15]
    
    enum StartEnd {
        case Start
        case End
    }
    
    func getLessonDate(pos: Int, when: StartEnd) -> NSDate {
        
        let startOfDay = calendar.startOfDayForDate(date)
        
        var lessonStart = calendar.dateBySettingUnit(.Hour, value: startHours[pos], ofDate: startOfDay, options: NSCalendarOptions.MatchFirst)
        
        lessonStart = calendar.dateBySettingUnit(.Minute, value: startMinutes[pos], ofDate: lessonStart!, options: NSCalendarOptions.MatchFirst)
        
        var lessonEnd = calendar.dateBySettingUnit(.Hour, value: endHours[pos], ofDate: startOfDay, options: NSCalendarOptions.MatchFirst)
        
        lessonEnd = calendar.dateBySettingUnit(.Minute, value: endMinutes[pos], ofDate: lessonEnd!, options: NSCalendarOptions.MatchFirst)
        
        if when == .Start {
            return lessonStart!
        } else {
            return lessonEnd!
        }
    }
    
    func getLessonTimeAsString(pos: Int, when: StartEnd) -> String {
        let time: String
        
        formatter.dateFormat = "HH:mm"
        time = formatter.stringFromDate(getLessonDate(pos, when: when))
        
        return time
    }
    
    func getCurrentLesson() -> [Int] {
        var arrayToReturn: [Int] = []
        
        for i in 0 ..< 12 {
            let selectedLessonEnd = getLessonDate(i, when: .End)
            if calendar.compareDate(date, toDate: selectedLessonEnd, toUnitGranularity: .Minute) == NSComparisonResult.OrderedDescending {
                if i != 11 {
                    arrayToReturn = [i]
                    arrayToReturn.append(calendar.component(.Weekday, fromDate: date))
                    break
                } else {
                    arrayToReturn = [0]
                    arrayToReturn.append(calendar.component(.Weekday, fromDate: date) + 1)
                    print("CurrentLesson is on next Day")
                }
            } else {
                arrayToReturn = [0]
            }
        }
        print(arrayToReturn)
        
        return arrayToReturn
    }
 }
