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
    
    let emptyUILesson = UILesson(subject: "", teacher: "", room: "", status: .Default, subsubject: "", subteacher: "", subroom: "")
    var i = 0
    var a = 0
    var allLessons = []
    var alreadyPicked: Array<TimeTableData>!
    
    var day: Int = -1
    
    func getNewLessonForUI(sec: Int, item: Int) -> UILesson {
        let storage = TimeTableStorage()
        if allLessons == [] {
            allLessons = storage.getTimeTableData()
        }
        
        let dayArray: [String] = dayGetter.generateDayArray(.long, forUI: false)
        let requestedDay: String = dayArray[item - 1]
        
        let timeArray: [String] = timeGetter.getLessonTimeAsStringArray(.Start, withSeconds: true)
        let requestedTime: String = timeArray[sec - 1]
        
        /*if allLessons != [] {
            let dayArray: [String] = dayGetter.generateDayArray(.long, forUI: false)
            let requestedDay: String = dayArray[item - 1]
            
            let timeArray: [String] = timeGetter.getLessonTimeAsStringArray(.Start, withSeconds: true)
            let requestedTime: String = timeArray[sec - 1]
            print("requestedTime: \((requestedDay + "T" + requestedTime + "+01:00"))")
            
            let lessonsInDay: NSMutableArray = []
            
            // Check if the requested item has changed since last request
            if day != item {
                day = item
                for i in 0 ..< allLessons.count {
                    if (allLessons[i] as! TimeTableData).day == requestedDay {
                        lessonsInDay.addObject(allLessons[i])
                        print("lesson starttime: \((allLessons[i] as! TimeTableData).startTime)")
                    }
                }
            }
            
            var UILessonToReturn: UILesson = emptyUILesson
            
            for i in 0 ..< lessonsInDay.count {
                if (lessonsInDay[i] as! TimeTableData).startTime == (requestedDay + "T" + requestedTime + "+01:00") {
                    let lessonToReturn = lessonsInDay[i] as! TimeTableData
                    print("true")
                    print(lessonToReturn.subject)
                    print(lessonToReturn.startTime)
                    UILessonToReturn = UILesson(subject: lessonToReturn.subject, teacher: lessonToReturn.teacher, room: lessonToReturn.location, status: .Default, subsubject: "", subteacher: "", subroom: "")
                    
                }
            }
            
            return UILessonToReturn
        } else {
            return emptyUILesson
        }
    }*/
        let LessonForUI: UILesson
        
        for i in 0 ..< allLessons.count {
            let lesson = allLessons[i]
            let lessonDateIsRequested = (lesson as! TimeTableData).startTime == (requestedDay + "T" + requestedTime + "+01:00")
            
            print((lesson as! TimeTableData).day)
            print("requested"+requestedDay)
            
            
            if alreadyPicked != nil {
                for a in 0..<alreadyPicked.count {
                    let lessonIsAlreadyPicked = (lesson as! TimeTableData).id == alreadyPicked[a].id
                    if !lessonIsAlreadyPicked {
                        if lessonDateIsRequested {
                            LessonForUI = UILesson(subject: (lesson as! TimeTableData).subject, teacher: (lesson as! TimeTableData).teacher, room: (lesson as! TimeTableData).location, status: .Default, subsubject: "", subteacher: "", subroom: "")
                            alreadyPicked.append((lesson as! TimeTableData))
                            
                            return LessonForUI
                            }
                        }
                    }
                } else {
                    if lessonDateIsRequested {
                        
                        LessonForUI = UILesson(subject: (lesson as! TimeTableData).subject, teacher: (lesson as! TimeTableData).teacher, room: (lesson as! TimeTableData).location, status: .Default, subsubject: "", subteacher: "", subroom: "")
                        alreadyPicked = [(lesson as! TimeTableData)]
                        return LessonForUI
                    }
                }
            }
        return emptyUILesson
    }
}