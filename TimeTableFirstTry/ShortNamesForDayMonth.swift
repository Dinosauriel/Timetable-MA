//
//  ShortNamesForDayMonth.swift
//  Timetable App
//
//  Created by Lukas Boner on 18.12.15.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import Foundation

class ShortNameForDayMonth {
    
    /**
     This function returns the short-name of a month
     The argument is an Integer representing the month
    */
    func month(monthNumber:Int) -> String {
        switch(monthNumber) {
        case 1: return "Jan"
        case 2: return "Feb"
        case 3: return "Mar"
        case 4: return "Apr"
        case 5: return "Mai"
        case 6: return "Jun"
        case 7: return "Jul"
        case 8: return "Aug"
        case 9: return "Sep"
        case 10: return "Oct"
        case 11: return "Nov"
        case 12: return "Dec"
        default: return "Jan"
        }
    }
    
    /**
     This function returns the short-name of a day
     The argument is an Integer representing the day
     */
    func day(dayNumber:Int) -> String {
        switch(dayNumber) {
        case 1: return "Sun"
        case 2: return "Mon"
        case 3: return "Tue"
        case 4: return "Wed"
        case 5: return "Thu"
        case 6: return "Fri"
        case 7: return "Sat"
        default: return "Mon"
        }
    }
    
}