//
//  Lesson.swift
//  TimeTableFirstTry
//
//  Created by Aurel Feer on 05.11.15.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import Foundation

class Lesson {
    
    let subject: String
    let teacher: String
    let room: String
    let status: Status
    let day: Day
    let lessonposition: Int
    
    init(subject:String, teacher:String, room:String, status: Status, day: Day, lessonposition: Int) {
        self.room = room
        self.teacher = teacher
        self.subject = subject
        self.status = status
        self.day = day
        self.lessonposition = lessonposition
    }
    
    enum Status {
        case Default
        case Moved
        case Cancelled
    }
    
    enum Day {
        case Monday
        case Thursday
        case Wednesday
        case Tuesday
        case Friday
    }
}
