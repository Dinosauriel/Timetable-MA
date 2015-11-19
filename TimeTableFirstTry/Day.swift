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
        let monday = NSLocalizedString("monday", comment: "TransForMon")
        let tuesday = NSLocalizedString("tuesday", comment: "TransForTue")
        let wednesday = NSLocalizedString("wednesday", comment: "TransForWed")
        let thursday = NSLocalizedString("thursday", comment: "TransForThu")
        let friday = NSLocalizedString("friday", comment: "TransForFri")
        
        let week: [String] = [monday, tuesday, wednesday, thursday, friday]
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let currentWeekDayCal = calendar.components(.Weekday, fromDate: date)
        let currentWeekDay = currentWeekDayCal.weekday
        
        var weekToReturn: [String]
        
        switch currentWeekDay {
            case 3:
                weekToReturn = [tuesday,wednesday,thursday,friday,monday]
            case 4:
                weekToReturn = [wednesday,thursday,friday,monday,tuesday]
            case 5:
                weekToReturn = [thursday,friday,monday,tuesday,wednesday]
            case 6:
                weekToReturn = [friday,monday,tuesday,wednesday,thursday]
            default:
                weekToReturn = week
        }
        
        func getNextDay(distance: Int) -> String {
            
            let calendar = NSCalendar.currentCalendar()
            
            let day = calendar.dateByAddingUnit(.Day, value: distance, toDate: NSDate(), options: [])
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "dd. MMMM yyyy"
            
            let DateString = formatter.stringFromDate(day!)
            print(DateString)
            return DateString
            
        }
        
        for var i = 0; i < weekToReturn.count; ++i {
            weekToReturn[i].appendContentsOf(", ")
            weekToReturn[i].appendContentsOf(getNextDay(i))
        }
        
        return weekToReturn
    }
}