//
//  DeclareLesson.swift
//  TimeTableFirstTry
//
//  Created by Aurel Feer on 05.11.15.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import Foundation

class DeclareLesson {
    let storage = TimeTableStorage()
    
    func getNewLessonForUI(let day: Int,let pos: Int) -> Lesson {
        let week = storage.getTimeTableData() as! [TimeTableData]
        
        for var i = 0; i < week.count; ++i {
            if week[i].teacher
        }
        
        
        let alesson = Lesson(subject: "M", teacher: "Kl", room: "8D", status: .Default, day: .Monday, lessonposition: 1, subsubject: "S", subteacher: "Sc", subroom: "C", start: "07:45", end: "08:25")
        return alesson
    }
}