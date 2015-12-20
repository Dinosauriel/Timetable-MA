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
    let storage = TimeTableStorage()
    let allLessons: [TimeTableData] = TimeTableStorage().getTimeTableData()
    
    func getNewLessonForUI(sec: Int, item: Int) -> UILesson {
        ++a
        print("a: \(a)")
        
        print("allLessons: \(allLessons[0].day)")
        
        let dayArray: [String] = dayGetter.generateDayArray(.long, forUI: false)
        var lessonsInDay: [TimeTableData] = []
        for i in 0 ..< allLessons.count {
            if (allLessons[i] as! TimeTableData).day == dayArray[sec - 1] {
                let UILessonToReturn: UILesson = UILesson(subject: (allLessons[i] as! TimeTableData).subject, teacher: (allLessons[i] as! TimeTableData).teacher, room: (allLessons[i] as! TimeTableData).location, status: .Default, subsubject: "", subteacher: "", subroom: "")
                return UILessonToReturn
            }
        }
        let UILessonToReturn: UILesson = UILesson(subject: "Hi", teacher: "Hi", room: "Hi", status: .Default, subsubject: "", subteacher: "", subroom: "")
        
        return UILessonToReturn
        
    }
}