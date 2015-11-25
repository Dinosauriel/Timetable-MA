//
//  Lesson.swift
//  TimeTableFirstTry
//
//  Created by Aurel Feer on 05.11.15.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import Foundation

struct Lesson {
    
    let subject: String
    let teacher: String
    let room: String
    
    let subsubject: String
    let subteacher: String
    let subroom: String
    
    let status: Status
    let day: Day
    let lessonposition: Int
    
    let starttime: String
    let endtime: String

    
    init(subject:String, teacher:String, room:String, status: Status, day: Day, lessonposition: Int, subsubject: String, subteacher: String, subroom: String, start: String, end: String) {
        self.room = room
        self.teacher = teacher
        self.subject = subject
        
        self.subsubject = subsubject
        self.subteacher = subteacher
        self.subroom = subroom
        
        self.status = status
        self.day = day
        self.lessonposition = lessonposition
        
        self.starttime = start
        self.endtime = end
    }
    
    enum Status {
        case Default
        case Replaced
        case Cancelled
        case Empty
        case Special
    }
    
    enum Day {
        case Monday
        case Thursday
        case Wednesday
        case Tuesday
        case Friday
    }
}
