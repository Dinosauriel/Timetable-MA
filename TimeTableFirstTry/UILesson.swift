//
//  UILesson.swift
//  Timetable App
//
//  Created by Aurel Feer and Lukas Boner on 05.11.15.
//  Copyright © 2015 Aurel Feer and Lukas Boner. All rights reserved.
//

import Foundation

/**
An object that contains all Information needed for the display of a lesson
*/
struct UILesson {
    
    init(subject: String, teacher: String, room: String, status: Status, subsubject: String, subteacher: String, subroom: String) {
        self.room = room
        self.teacher = teacher
        self.subject = subject
        
        self.subsubject = subsubject
        self.subteacher = subteacher
        self.subroom = subroom
        
        self.status = status
    }
    
    var subject: String
    var teacher: String
    var room: String
    
    let subsubject: String
    let subteacher: String
    let subroom: String
    
    var status: Status
    
    enum Status {
        case Default
        case Replaced
        case Cancelled
        case Empty
        case Special
        case MovedTo
    }
    
    enum Day {
        case Monday
        case Thursday
        case Wednesday
        case Tuesday
        case Friday
    }
}
