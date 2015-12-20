//
//  DeclareLesson.swift
//  Timetable App
//
//  Created by Aurel Feer on 05.11.15.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import Foundation

class DeclareLesson {
    
    let dayArray: [String] = Day().generateDayArray(.long, forUI: false)
    let timeArray: [String] = ["07:45:00", "08:35:00", "09:25:00", "10:20:00", "11:10:00", "12:00:00", "12:45:00", "13:35:00", "14:25:00", "15:15:00", "16:05:00", "16:55:00"]
    let eventStartTimeString: String = "00:00:00"
    
    let timeZoneAppendix = "+01:00"
    let dateTimeSeparator = "T"
    
    let emptyUILesson = UILesson(subject: "", teacher: "", room: "", status: .Default, subsubject: "", subteacher: "", subroom: "")
    
    var requestedDay: String!
    var requestedTime: String!
    
    func getNewLessonForUI(sec: Int, item: Int) -> UILesson {
        let storage = TimeTableStorage()
        var requestedUILesson: UILesson = emptyUILesson
        
        requestedDay = dayArray[item - 1]
        requestedTime = timeArray[sec - 1]
        
        let requestedDate = requestedDay + dateTimeSeparator + requestedTime + timeZoneAppendix
        let requestedLessons: [TimeTableData] = storage.getTimeTableDataWithStarttime(requestedDate)
        
        let eventDate = requestedDay + dateTimeSeparator + eventStartTimeString + timeZoneAppendix
        let events: [TimeTableData] = storage.getTimeTableDataWithStarttime(eventDate)
        
        if requestedLessons.count == 1 {
            let requestedLesson: TimeTableData = requestedLessons[0]
            requestedUILesson = UILesson(subject: requestedLesson.subject, teacher: requestedLesson.teacher, room: requestedLesson.location, status: .Default, subsubject: "", subteacher: "", subroom: "")
            
            if events.count == 1 { //Checking for an event
                let event = events[0]
                requestedUILesson = UILesson(subject: event.subject, teacher: event.teacher, room: event.location, status: .Special, subsubject: "", subteacher: "", subroom: "")
                
            } else if events.count > 1 {
                
            } else {
                
            }

            
        } else if requestedLessons.count > 1 {  //More than one lesson at this Position
            
        } else if requestedLessons.count == 0 { //No lesson at this Position
            
        }
        
        return requestedUILesson
    }
}