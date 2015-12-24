//
//  Day.swift
//  TimeTableFirstTry
//
//  Created by Aurel Feer on 08.11.15.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import Foundation

class Day {
    //MARK: CLASSES
    let today = NSDate()
    let calendar = NSCalendar.currentCalendar()
    let formatter = NSDateFormatter()
    
    //MARK: INTEGERS
    let numberOfDaysInWeek = 5
    
    //MARK: ENUMERATIONS
    enum StringLength {
        case short
        case long
        case veryshort
    }
    
    /**
    Returns an Array of the days Needed in the Timetable
    */
    func generateDayArray(dateStringLength: StringLength, forUI: Bool) -> [String] {
        let demandedArrayLength: Int = 15
        var weekendCorrection = 0
        
        var weekToReturn: [String] = [String](count: demandedArrayLength, repeatedValue: "")
        
        var firstMonday: NSDate? = calendar.dateBySettingUnit(.Weekday, value: 2, ofDate: today, options: NSCalendarOptions.MatchFirst)
        //Getting first monday to be displayed
        
        let monIsLater: Bool = calendar.compareDate(firstMonday!, toDate: self.today, toUnitGranularity: .Weekday) == .OrderedDescending
        
        let isWeekend: Bool = calendar.component(.Weekday, fromDate: self.today) == 7 || calendar.component(.Weekday, fromDate: self.today) == 1
        
        if monIsLater && !isWeekend { //Adapting firstMonday if needed
            firstMonday = calendar.dateByAddingUnit(.WeekOfYear, value: -1, toDate: firstMonday!, options: NSCalendarOptions.MatchLast)
        }
        
        //Assmbling weekToReturn based on firstMonday including weekendCorrection
        for i in 0 ..< demandedArrayLength {
            if i % numberOfDaysInWeek == 0 && i != 0 {
                weekendCorrection += 2
            }
            
            let newDate = calendar.dateByAddingUnit(.Day, value: i + weekendCorrection, toDate: firstMonday!, options: NSCalendarOptions.MatchNextTime)
            let newString = getStringFromDate(newDate!, length: dateStringLength, forUI: forUI)
            weekToReturn[i] = newString
        }
        
        return weekToReturn
    }
    
    /**
    Returns String for date
    */
    func getStringFromDate(date: NSDate, length: StringLength, forUI: Bool) -> String {
        
        if forUI {
            if length == .long {
                formatter.dateFormat = "EEEE, dd. MMMM yyyy"
            } else if length == .short {
                formatter.dateFormat = "EE, dd. MM. yy"
            } else if length == .veryshort {
                formatter.dateFormat = "EE, dd. MM."
            }
        } else {
            formatter.dateFormat = "yyyy-MM-dd"
        }
        
        return formatter.stringFromDate(date)
    }
}