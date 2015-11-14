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
        let currentWeekDay = calendar.components(.Weekday, fromDate: date)
        let currentDay = currentWeekDay.weekday

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