//
//  Lesson.swift
//  TimeTableFirstTry
//
//  Created by Aurel Feer on 05.11.15.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import Foundation

struct UILesson {
    
    let subject: String
    let teacher: String
    let room: String
    
    let subsubject: String
    let subteacher: String
    let subroom: String
    
    let status: Status


    
    init(subject: String, teacher: String, room: String, status: Status, subsubject: String, subteacher: String, subroom: String) {
        self.room = room
        self.teacher = teacher
        self.subject = subject
        
        self.subsubject = subsubject
        self.subteacher = subteacher
        self.subroom = subroom
        
        self.status = status
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
