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
        let monday = "Montag"
        let tuesday = "Dienstag"
        let wednesday = "Mittwoch"
        let thursday = "Donnerstag"
        let friday = "Freitag"
        
        let week = [monday, tuesday, wednesday, thursday, friday]
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let currentDate = calendar.components(.Weekday, fromDate: date)
        let currentDay = currentDate.weekday

        print("Day \(currentDay)")
        
        switch currentDay {
            case 3:
                return [tuesday,wednesday,thursday,friday,monday]
            case 4:
                return [wednesday,thursday,friday,monday,tuesday]
            case 5:
                return [thursday,friday,monday,tuesday,wednesday]
            case 6:
                return [friday,monday,tuesday,wednesday,thursday]
            default:
                return week
        }
    }
}