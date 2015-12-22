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
    
    let numberOfLessonsInDay = 12
    
    let startHours = [7, 8, 9, 10, 11, 12, 12, 13, 14, 15, 16, 16, 17]
    let startMinutes = [45, 35, 25, 20, 10, 00, 45, 35, 25, 15, 05, 50, 35]
    
    let endHours = [8, 9, 10, 11, 11, 12, 13, 14, 15, 15, 16, 17, 18]
    let endMinutes = [25, 15, 05, 00, 50, 40, 25, 15, 05, 55, 45, 30, 15]
    
    var startDates: [NSDate] = []
    var endDates: [NSDate] = []
    
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
    
    func generateDateArrays() {
        if startDates == [] || endDates == [] {
            for i in 0 ..< 12 {
                startDates.append(getLessonDate(i, when: .Start))
                endDates.append(getLessonDate(i, when: .End))
            }
        }
    }
    
    func getLessonTimeAsString(pos: Int, when: StartEnd, withSeconds: Bool) -> String {
        generateDateArrays()
        let time: String
        
        if withSeconds {
            self.formatter.dateFormat = "HH:mm:ss"
        } else {
            self.formatter.dateFormat = "HH:mm"
        }
        if when == .End {
            time = formatter.stringFromDate(endDates[pos])
        } else {
            time = formatter.stringFromDate(startDates[pos])
        }
        
        return time
    }
    
    
    func getLessonTimeAsStringArray(when: StartEnd, withSeconds: Bool) -> [String] {
        var ArrayToReturn: [String] = []
        
        for i in 0 ..< numberOfLessonsInDay {
            ArrayToReturn.append(getLessonTimeAsString(i, when: when, withSeconds: withSeconds))
        }
        
        return ArrayToReturn
    }
    
    func getCurrentLessonCoordinates() -> [Int] {
        generateDateArrays()
        var currentLesson: Int = 0
        
        for i in 0 ..< 12 {
            let selectedLessonEnd = endDates[i]
            if calendar.compareDate(selectedLessonEnd, toDate: date, toUnitGranularity: .Minute) == NSComparisonResult.OrderedDescending {
                currentLesson = i
                break
            }
        }
        let arrayToReturn: [Int] = [getCurrentWeekDayInWorkWeek(), currentLesson]
        
        return arrayToReturn
    }
    
    func getCurrentWeekDayInWorkWeek() -> Int {
        generateDateArrays()
        var weekDay = calendar.component(.Weekday, fromDate: date)
        let lastLessonEnd = endDates[11]
        if calendar.compareDate(date, toDate: lastLessonEnd, toUnitGranularity: .Minute) == .OrderedDescending {
            ++weekDay
        }
        
        if weekDay == 1 || weekDay == 7 {
            weekDay = 2
        }
        
        return weekDay
    }
    
    /*func lessonIsCurrentLesson(item: Int, inSection: Int) -> Bool {
        let coordinates: [Int] = getCurrentLessonCoordinates()
        print(coordinates)
        let xDay: Int = coordinates[0] - 1
        let yTime: Int = coordinates[1] + 1
        
        return ((item == xDay) && (inSection == yTime))
    }*/
    
    /*func dayIsCurrentDay(item: Int) -> Bool {
        let coordinates: [Int] = getCurrentLessonCoordinates()
        return item == coordinates[0] - 1
    }*/
 }
