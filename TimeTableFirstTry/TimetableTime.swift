//
//  TimetableTime.swift
//  TimeTableFirstTry
//
//  Created by Aurel Feer on 02.11.15.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import Foundation

public class TimetableTime {
    
    let startTimes = ["07:45","08:35","09:25","10:20","11:10","12:00","12:45","13:35","14:25","15:15","16:05","16:55"]
    let endTimes = ["08:25","09:15","10:05","11:00","11:50","12:40","13:25","14:15","15:05","15:55","16:45","17:35"]
    
    enum relpos {
        case earlier
        case later
        case equal
    }
    
    func getLessonTime(let lessonposition:Int, let when:String) -> NSDateComponents {
        
        let starttime = NSDateComponents()
        let endtime = NSDateComponents()
        
        switch lessonposition {
        case 1:
            starttime.hour = 7
            starttime.minute = 45
            endtime.hour = 8
            endtime.minute = 25
        case 2:
            starttime.hour = 8
            starttime.minute = 35
            endtime.hour = 9
            endtime.minute = 15
        case 3:
            starttime.hour = 9
            starttime.minute = 25
            endtime.hour = 10
            endtime.minute = 5
        case 4:
            starttime.hour = 10
            starttime.minute = 20
            endtime.hour = 11
            endtime.minute = 0
        case 5:
            starttime.hour = 11
            starttime.minute = 10
            endtime.hour = 11
            endtime.minute = 50
        case 6:
            starttime.hour = 12
            starttime.minute = 0
            endtime.hour = 12
            endtime.minute = 40
        case 7:
            starttime.hour = 12
            starttime.minute = 45
            endtime.hour = 13
            endtime.minute = 25
        case 8:
            starttime.hour = 13
            starttime.minute = 35
            endtime.hour = 14
            endtime.minute = 15
        case 9:
            starttime.hour = 14
            starttime.minute = 25
            endtime.hour = 15
            endtime.minute = 5
        case 10:
            starttime.hour = 15
            starttime.minute = 15
            endtime.hour = 15
            endtime.minute = 55
        case 11:
            starttime.hour = 16
            starttime.minute = 5
            endtime.hour = 16
            endtime.minute = 45
        case 12:
            starttime.hour = 16
            starttime.minute = 55
            endtime.hour = 17
            endtime.minute = 35
        default:
            starttime.hour = 0
            starttime.minute = 0
            endtime.hour = 0
            endtime.minute = 0
        }
        
        if when == "end" {
            return endtime
        } else {
            return starttime
        }
    }
    
    func getLessonTimeAsString(let lessonposition:Int, let when:String) -> String {
        var timeasString: String
        let timeasNSDateComponent = getLessonTime(lessonposition, when: when)
        var hourAsString = timeasNSDateComponent.hour.description
        var minuteAsString = timeasNSDateComponent.minute.description
        
        if hourAsString.characters.count == 1 {
            hourAsString = addZero(hourAsString)
        }
        if minuteAsString.characters.count == 1 {
            minuteAsString = addZero(minuteAsString)
        }
        
        timeasString = hourAsString
        timeasString.appendContentsOf(":")
        timeasString.appendContentsOf(minuteAsString)
        
        return timeasString
    }
    
    func addZero(let inputString:String) -> String {
        var zerostring = "0"
        zerostring.appendContentsOf(inputString)
        return zerostring
    }
    
    func timeAsStringToLessonposition(let time:String) -> Int {
        if endTimes.contains(time) {
            
            return endTimes.indexOf(time)! + 1
        } else if startTimes.contains(time) {
            
            return startTimes.indexOf(time)! + 1
        } else {
            
            return 0
        }
    }
    
    func timeAsStringToWhen(let time: String) -> String {
        if endTimes.contains(time) {
            return "end"
        } else if startTimes.contains(time) {
            return "start"
        } else {
            return "time not found"
        }
    }
    
    func timeAsStringToNSDateComponents(let time:String) -> NSDateComponents {
        let lessonposition = timeAsStringToLessonposition(time)
        let lessonwhen = timeAsStringToWhen(time)
        return getLessonTime(lessonposition, when: lessonwhen)
    }
    
    func compareNSDateComponentsAtoB(a: NSDateComponents, b: NSDateComponents) -> relpos {

        if a.hour < b.hour {
            
            return .earlier
            
        } else if a.hour > b.hour {
            
            return .later
            
        } else {
            
            if a.minute < b.hour {
                
                return .earlier
                
            } else if a.minute > b.hour {
                
                return .later
                
            } else {
                
                return .equal
                
            }
        }
    }
    
    func getCurrentHourAndMinute() -> NSDateComponents {
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let currentHourCal = calendar.components(.Hour, fromDate: date)
        let currentMinCal = calendar.components(.Minute, fromDate: date)
        let currentTime = NSDateComponents()
        currentTime.hour = currentHourCal.hour
        currentTime.minute = currentMinCal.minute
        
        
        return currentTime
    }
}
