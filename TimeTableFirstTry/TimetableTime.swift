//
//  TimetableTime.swift
//  Timetable App
//
//  Created by Aurel Feer and Lukas Boner on 02.11.15.
//  Copyright © 2015 Aurel Feer and Lukas Boner. All rights reserved.
//

import Foundation

class TimetableTime {
    
    //MARK: CLASSES
    let date = Date()
    let calendar = Calendar.current
    let formatter = DateFormatter()
    
    //MARK: INTEGERS
    let numberOfLessonsInDay = 12
    
    //MARK: ARRAYS
    let startHours = [7, 8, 9, 10, 11, 12, 12, 13, 14, 15, 16, 16, 17]
    let startMinutes = [45, 35, 25, 20, 10, 00, 45, 35, 25, 15, 05, 50, 35]
    
    let endHours = [8, 9, 10, 11, 11, 12, 13, 14, 15, 15, 16, 17, 18]
    let endMinutes = [25, 15, 05, 00, 50, 40, 25, 15, 05, 55, 45, 30, 15]
    
    var startDates: [Date] = []
    var endDates: [Date] = []
    
    //MARK: ENUMERATIONS
    enum StartEnd {
        case start
        case end
    }
    
    /**
    Returns a NSDate of the start or end of a lesson in the Timetable
    */
    func getLessonDate(_ pos: Int, when: StartEnd) -> Date {
        
        //Getting Start of Day
        let startOfDay = calendar.startOfDay(for: date)
        
        //Adding minutes and hours to lessonStart and lessonEnd
        var lessonStart = (calendar as NSCalendar).date(bySettingUnit: .hour, value: startHours[pos], of: startOfDay, options: NSCalendar.Options.matchFirst)
        
        lessonStart = (calendar as NSCalendar).date(bySettingUnit: .minute, value: startMinutes[pos], of: lessonStart!, options: NSCalendar.Options.matchFirst)
        
        var lessonEnd = (calendar as NSCalendar).date(bySettingUnit: .hour, value: endHours[pos], of: startOfDay, options: NSCalendar.Options.matchFirst)
        
        lessonEnd = (calendar as NSCalendar).date(bySettingUnit: .minute, value: endMinutes[pos], of: lessonEnd!, options: NSCalendar.Options.matchFirst)
        
        if when == .start {
            return lessonStart!
        } else {
            return lessonEnd!
        }
    }
    
    /**
    Generates date Arrays and assigns them to StartDates and EndDates
    */
    func generateDateArrays() {
        if startDates == [] || endDates == [] { //Check if Arrays are empty
            for i in 0 ..< 12 {
                startDates.append(getLessonDate(i, when: .start))
                endDates.append(getLessonDate(i, when: .end))
            }
        }
    }
    
    /**
    Returns a String with the endTime or StartTime at the requested position
    */
    func getLessonTimeAsString(_ pos: Int, when: StartEnd, withSeconds: Bool) -> String {
        generateDateArrays()
        let time: String
        
        if withSeconds {
            self.formatter.dateFormat = "HH:mm:ss"
        } else {
            self.formatter.dateFormat = "HH:mm"
        }
        if when == .end {
            time = formatter.string(from: endDates[pos])
        } else {
            time = formatter.string(from: startDates[pos])
        }
        
        return time
    }
    
    /**
    Returns an Array of all lessonTimes needed in the Timetable
    */
    func getLessonTimeAsStringArray(_ when: StartEnd, withSeconds: Bool) -> [String] {
        var ArrayToReturn: [String] = []
        
        for i in 0 ..< numberOfLessonsInDay {
            ArrayToReturn.append(getLessonTimeAsString(i, when: when, withSeconds: withSeconds))
        }
        
        return ArrayToReturn
    }
    
    /**
    Returns an Array with the day-coordinates and time-coordinates of the current lesson
    */
    func getCurrentLessonCoordinates() -> [Int] {
        generateDateArrays()
        var currentLesson: Int = 0
        
        /**
        Iterate through all the times and break if there is one later than now
        */
        for i in 0 ..< 12 {
            let selectedLessonEnd = endDates[i]
            if (calendar as NSCalendar).compare(selectedLessonEnd, to: date, toUnitGranularity: .minute) == ComparisonResult.orderedDescending {
                currentLesson = i
                break
            }
        }
        let arrayToReturn: [Int] = [getCurrentWeekDayInWorkWeek(), currentLesson]
        
        return arrayToReturn
    }
    
    /**
    Returns the currently active day
    */
    func getCurrentWeekDayInWorkWeek() -> Int {
        generateDateArrays()
        var weekDay = (calendar as NSCalendar).component(.weekday, from: date)
        let lastLessonEnd = endDates[11]
        
        //Skip to next day if the last lesson has ended
        if (calendar as NSCalendar).compare(date, to: lastLessonEnd, toUnitGranularity: .minute) == .orderedDescending {
            weekDay += 1
        }
        
        //Skip weekend
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
