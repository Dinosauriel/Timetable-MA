//
//  Day.swift
//  TimeTableFirstTry
//
//  Created by Aurel Feer on 08.11.15.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import Foundation

class Day {
    func generateDayArray() -> NSArray {

        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let currentWeekDayCal = calendar.components(.Weekday, fromDate: date)
        let currentWeekDay = currentWeekDayCal.weekday
        
        var weekToReturn = [String](count: 5, repeatedValue: "")
        
        
        func getNextDay(distance: Int) -> String {
            var day = calendar.dateBySettingUnit(.Weekday, value: (2 + distance), ofDate: NSDate(), options: NSCalendarOptions())
            
            let weekdayCal = calendar.component(.Weekday, fromDate: day!)
            
            if weekdayCal < currentWeekDay && currentWeekDay != 7 {
                day = calendar.dateByAddingUnit(.WeekOfYear, value: -1, toDate: day!, options: NSCalendarOptions())
            }
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEEE, dd. MMMM yyyy"
            
            let DateString = formatter.stringFromDate(day!)
            return DateString
        }
        
        for var i = 0; i < weekToReturn.count; ++i {
            weekToReturn[i] = getNextDay(i)

        }
        
        return weekToReturn
    }
}