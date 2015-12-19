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
    
    func getNewLessonForUI(sec: Int, item: Int) -> UILesson {
        let storage = TimeTableStorage()
        
        let allLessonsSortedByDay: [String: [TimeTableData]] = storage.getTimeTableDict()
        
        let dayArray: [String] = dayGetter.generateDayArray(.long, forUI: false)
        
        let requestedDayString: String = dayArray[item - 1]
        
        if allLessonsSortedByDay != ["failed":[]] {
            let requestedDay: [TimeTableData] = allLessonsSortedByDay[requestedDayString]!
        
            let requestedStorageLesson: TimeTableData = requestedDay[sec - 1]
        
            let LessonForUI: UILesson = UILesson(subject: requestedStorageLesson.subject, teacher: requestedStorageLesson.teacher, room: requestedStorageLesson.location, status: .Default, subsubject: "", subteacher: "", subroom: "", start: "", end: "")
        
            return LessonForUI
        } else {
            return UILesson(subject: "", teacher: "", room: "", status: .Empty, subsubject: "", subteacher: "", subroom: "", start: "", end: "")
        }
    }
}