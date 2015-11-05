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
    
    init(subject:String, teacher:String, room:String, status: Status) {
        self.room = room
        self.teacher = teacher
        self.subject = subject
        self.status = Status.Default
    }
    
    enum Status {
        case Default
        case Moved
        case Cancelled
    }
    
}
