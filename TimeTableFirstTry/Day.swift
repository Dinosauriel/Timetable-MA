//
//  Day.swift
//  TimeTableFirstTry
//
//  Created by Aurel Feer on 08.11.15.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import Foundation

class Day {
    let today = NSDate()
    let calendar = NSCalendar.currentCalendar()
    let formatter = NSDateFormatter()
    
    let numberOfDaysInWeek = 5
    
    enum StringLength {
        case short
        case long
    }
    
    func generateDayArray(dateStringLength: StringLength) -> [String] {
        let demandedArrayLength: Int = 15
        var weekendCorrection = 0
        
        var weekToReturn: [String] = [String](count: demandedArrayLength, repeatedValue: "")
        
        var firstMonday = calendar.dateBySettingUnit(.Weekday, value: 2, ofDate: today, options: NSCalendarOptions.MatchLast)
        
        let monIsLater = calendar.compareDate(firstMonday!, toDate: today, toUnitGranularity: .Weekday) == .OrderedDescending
        
        if monIsLater {
            firstMonday = calendar.dateByAddingUnit(.WeekOfYear, value: -1, toDate: firstMonday!, options: NSCalendarOptions.MatchLast)
        }
        
        for i in 0 ..< demandedArrayLength {
            if i % numberOfDaysInWeek == 0 && i != 0 {
                weekendCorrection += 2
            }
            
            let newDate = calendar.dateByAddingUnit(.Day, value: i + weekendCorrection, toDate: firstMonday!, options: NSCalendarOptions.MatchNextTime)
            let newString = getStringFromDate(newDate!, length: dateStringLength)
            weekToReturn[i] = newString
        }
        
        return weekToReturn
    }
    
    func getStringFromDate(date: NSDate, length: StringLength) -> String {
        if length == .long {
            formatter.dateFormat = "EEEE, dd. MMMM yyyy"
        } else if length == .short {
            formatter.dateFormat = "EE, dd. MM. yy"
        }
        return formatter.stringFromDate(date)
    }
}