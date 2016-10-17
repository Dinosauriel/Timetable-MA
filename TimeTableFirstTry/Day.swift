//
//  Day.swift
//  Timetable App
//
//  Created by Aurel Feer and Lukas Boner on 08.11.15.
//  Copyright © 2015 Aurel Feer and Lukas Boner. All rights reserved.
//

import Foundation

class Day {
    //MARK: CLASSES
    let today = Date()
    let calendar = Calendar.current
    let formatter = DateFormatter()
    
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
    func generateDayArray(_ dateStringLength: StringLength, forUI: Bool) -> [String] {
        let demandedArrayLength: Int = 15
        var weekendCorrection = 0
        
        var weekToReturn: [String] = [String](repeating: "", count: demandedArrayLength)
        
        var firstMonday: Date? = (calendar as NSCalendar).date(bySettingUnit: .weekday, value: 2, of: today, options: NSCalendar.Options.matchFirst)
        //Getting first monday to be displayed
        
        let monIsLater: Bool = (calendar as NSCalendar).compare(firstMonday!, to: self.today, toUnitGranularity: .weekday) == .orderedDescending
        
        let isWeekend: Bool = (calendar as NSCalendar).component(.weekday, from: self.today) == 7 || (calendar as NSCalendar).component(.weekday, from: self.today) == 1
        
        if monIsLater && !isWeekend { //Adapting firstMonday if needed
            firstMonday = (calendar as NSCalendar).date(byAdding: .weekOfYear, value: -1, to: firstMonday!, options: NSCalendar.Options.matchLast)
        }
        
        //Assmbling weekToReturn based on firstMonday including weekendCorrection
        for i in 0 ..< demandedArrayLength {
            if i % numberOfDaysInWeek == 0 && i != 0 {
                weekendCorrection += 2
            }
            
            let newDate = (calendar as NSCalendar).date(byAdding: .day, value: i + weekendCorrection, to: firstMonday!, options: NSCalendar.Options.matchNextTime)
            let newString = getStringFromDate(newDate!, length: dateStringLength, forUI: forUI)
            weekToReturn[i] = newString
        }
        
        return weekToReturn
    }
    
    /**
    Returns String for date
    */
    func getStringFromDate(_ date: Date, length: StringLength, forUI: Bool) -> String {
        
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
        
        return formatter.string(from: date)
    }
}
