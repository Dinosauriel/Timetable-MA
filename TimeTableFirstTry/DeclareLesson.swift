//
//  DeclareLesson.swift
//  Timetable App
//
//  Created by Aurel Feer on 05.11.15.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import Foundation

class DeclareLesson {
    let dayGetter = Day()
    let timeGetter = TimetableTime()
    
    let dayArray: [String] = Day().generateDayArray(.long, forUI: false)
    let timeArray: [String] = ["07:45:00", "08:35:00", "09:25:00", "10:20:00", "11:10:00", "12:00:00", "12:45:00", "13:35:00", "14:25:00", "15:15:00", "16:05:00", "16:55:00"]
    
    let emptyUILesson = UILesson(subject: "", teacher: "", room: "", status: .Default, subsubject: "", subteacher: "", subroom: "")
    
    var requestedDay: String!
    var requestedTime: String!
    
    var day: Int = -1
    var lespos: Int = -1
    
    func getNewLessonForUI(sec: Int, item: Int) -> UILesson {
        let storage = TimeTableStorage()
        var requestedUILesson: UILesson = emptyUILesson
        
        requestedDay = dayArray[item - 1]
        requestedTime = timeArray[sec - 1]
        
        let requestedDate = requestedDay + "T" + requestedTime + "+01:00"
        
        let requestedLessons: [TimeTableData] = storage.getTimeTableDataWithStarttime(requestedDate)
        
        if requestedLessons.count == 1 {
            let requestedLesson = requestedLessons[0]
            requestedUILesson = UILesson(subject: requestedLesson.subject, teacher: requestedLesson.teacher, room: requestedLesson.location, status: .Default, subsubject: "", subteacher: "", subroom: "")
        } else if requestedLessons.count > 1 {
            
        } else {
            
        }
        
        return requestedUILesson
    }
}