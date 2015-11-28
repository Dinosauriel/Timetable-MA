//
//  DeclareLesson.swift
//  TimeTableFirstTry
//
//  Created by Aurel Feer on 05.11.15.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import Foundation

class DeclareLesson {
    
    func getNewLessonForUI(let day: Int,let pos: Int) -> Lesson {
        let storage = TimeTableStorage()
        let week = storage.getTimeTableData()
        var day: [TimeTableData] = []
        var start: String
        var UILesson = Lesson(subject: "", teacher: "", room: "", status: .Empty, subsubject: "", subteacher: "", subroom: "", start: "", end: "")
        
        for var i = 0; i < week.count; ++i {
            if week[i].day == "3" {
                day.append(week[i])
            }
        }
        
        //print(day)
        
        switch pos {
            case 1:
                start = "07:45:00"
            case 2:
                start = "08:35:00"
            case 3:
                start = "09:25:00"
            case 4:
                start = "10:20:00"
            case 5:
                start = "11:10:00"
            case 6:
                start = "12:00:00"
            case 7:
                start = "12:45:00"
            case 8:
                start = "13:35:00"
            case 9:
                start = "14:25:00"
            case 10:
                start = "15:15:00"
            case 11:
                start = "16:05:00"
            case 12:
                start = "16:55:00"
            default:
                start = ""
        }
        
        for var i = 0; i < day.count; ++i {
            if day[i].startTime == start {
                let STORLesson = day[i]
                UILesson = Lesson(subject: STORLesson.subject, teacher: STORLesson.teacher, room: STORLesson.location, status: .Default, subsubject: "", subteacher: "", subroom: "", start: STORLesson.startTime, end: STORLesson.endTime)
            }
        }
        
        
        return UILesson
    }
}