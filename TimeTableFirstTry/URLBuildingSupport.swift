//
//  ShortNamesForDayMonth.swift
//  Timetable App
//
//  Created by Lukas Boner and Aurel Feer on 18.12.15.
//  Copyright © 2015 Aurel Feer and Lukas Boner. All rights reserved.
//

import Foundation

class URLBuildingSupport {
    
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
    
    func getURLForCurrentDate(token:String) -> String {
        let URLBaseRequestString = "https://intranet.tam.ch/klw/rest/mobile-timetable/auth/"
        
        //The resource-string for the data with filters
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day,.Month,.Year,.Weekday,.Hour,.Minute,.Second], fromDate: date)
        
        let dayVarShort:String = day(components.day)
        let dayVarDate:String = String(components.day)
        let monthVarShort:String = month(components.month)
        let yearVar:String = String(components.year)
        let hourVar:String = String(components.hour)
        let minuteVar:String = String(components.minute)
        let secondVar:String = String(components.second)
        let timeZoneVar:String = "GMT"
        
        
        return URLBaseRequestString + token + "/date/" + dayVarShort + "%2C%20" + dayVarDate + "%20" + monthVarShort + "%20" + yearVar + "%20" + hourVar + "%3A" + minuteVar + "%3A" + secondVar + "%20" + timeZoneVar
    }
    
}
