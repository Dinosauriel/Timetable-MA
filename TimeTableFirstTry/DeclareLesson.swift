//
//  DeclareLesson.swift
//  TimeTableFirstTry
//
//  Created by Aurel Feer on 05.11.15.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import Foundation

class DeclareLesson {
    
    func getNewLessonForUI(let sec: Int,let pos: Int) -> UILesson {
        let startTimes = ["07:45:00", "08:35:00", "09:25:00", "10:20:00", "11:10:00", "12:00:00", "12:45:00", "13:35:00", "14:25:00", "15:15:00", "16:05:00", "16:55:00"]
        
        let storage = TimeTableStorage()
        let week = storage.getTimeTableData()
        var day: [TimeTableData] = []
        var start: String
        var LessonForUI = UILesson(subject: "", teacher: "", room: "", status: .Empty, subsubject: "", subteacher: "", subroom: "", start: "", end: "")
        
        for var i = 0; i < week.count; ++i {
            if week[i].day == String(sec) {
                day.append(week[i])
            }
        }
        
        start = startTimes[pos - 1]
        
        func detMultLessonForPos() -> Bool {
            
            var lescount = 0
            for var a = 0; a < day.count; ++a {
                if day[a].startTime == start {
                    ++lescount
                }
            }
            print(lescount)
            return (lescount > 1)
        }
        //print("\(detMultLessonForPos()) sub: \(day[pos].subject)")


        for var i = 0; i < day.count; ++i {
            if day[i].startTime == start {
                let STORLesson = day[i]
                LessonForUI = UILesson(subject: STORLesson.subject, teacher: STORLesson.teacher, room: STORLesson.location, status: .Default, subsubject: "", subteacher: "", subroom: "", start: STORLesson.startTime, end: STORLesson.endTime)
                            }
        }
        
        
        return LessonForUI
    }
}