//
//  DeclareLesson.swift
//  TimeTableFirstTry
//
//  Created by Aurel Feer on 05.11.15.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import Foundation

class DeclareLesson {
    let dayGetter = Day()
    var i = 0
    var a = 0
    var allLessons = []
    var alreadyPicked:Array<TimeTableData>!
    
    func getNewLessonForUI(sec: Int, item: Int) -> UILesson {
        let storage = TimeTableStorage()
        if allLessons == [] {
            allLessons = storage.getTimeTableData()
        }
        
        ++a
        //print("a: \(a)")
        
        
        let dayArray: [String] = dayGetter.generateDayArray(.long, forUI: false)
        
        let requestedDayString: String = dayArray[item - 1]
        //print(allLessons)
        let LessonForUI: UILesson
        if allLessons != [] {
            
            for i in 0..<allLessons.count {
                let lesson = allLessons[i]
                print((lesson as! TimeTableData).day)
                print("requested"+requestedDayString)
                if alreadyPicked != nil {
                    for a in 0..<alreadyPicked.count {
                        if (lesson as! TimeTableData).id == alreadyPicked[a].id {
                            
                        } else {
                            if (lesson as! TimeTableData).day == requestedDayString{
                                LessonForUI = UILesson(subject: (lesson as! TimeTableData).subject, teacher: (lesson as! TimeTableData).teacher, room: (lesson as! TimeTableData).location, status: .Default, subsubject: "", subteacher: "", subroom: "")
                                alreadyPicked.append((lesson as! TimeTableData))
                                return LessonForUI
                            }
                        }
                    }
                } else {
                    if (lesson as! TimeTableData).day == requestedDayString {
                        LessonForUI = UILesson(subject: (lesson as! TimeTableData).subject, teacher: (lesson as! TimeTableData).teacher, room: (lesson as! TimeTableData).location, status: .Default, subsubject: "", subteacher: "", subroom: "")
                        alreadyPicked = [(lesson as! TimeTableData)]
                        return LessonForUI
                    }
                }
            }
            
            /*let requestedDay: [TimeTableData] = allLessonsSortedByDay[requestedDayString]!
        
            let requestedStorageLesson: TimeTableData = requestedDay[sec - 1]
        
            let LessonForUI: UILesson = UILesson(subject: requestedStorageLesson.subject, teacher: requestedStorageLesson.teacher, room: requestedStorageLesson.location, status: .Default, subsubject: "", subteacher: "", subroom: "")*/
        
            return UILesson(subject: "a", teacher: "b", room: "c", status: .Default, subsubject: "", subteacher: "", subroom: "")
            
            
        } else {
            ++i
            //print("i: \(i)")
            return UILesson(subject: "1", teacher: "2", room: "3", status: .Default, subsubject: "", subteacher: "", subroom: "")
        }
    }
}