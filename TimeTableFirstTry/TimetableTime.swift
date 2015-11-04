//
    
    //  TimeGetter.swift
    
    //  TimeTableFirstTry
    
    //
    
    //  Created by Aurel Feer on 02.11.15.
    
    //  Copyright © 2015 Aurel Feer. All rights reserved.
    
    //
    
    
    
import Foundation


    
public class TimetableTime {

    //GITHUB BUG: FILE CANT COMMIT
    
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
        timeasString = timeasNSDateComponent.hour.description
        timeasString.appendContentsOf(":")
        timeasString.appendContentsOf(timeasNSDateComponent.minute.description)
        
        return timeasString
    }
}
