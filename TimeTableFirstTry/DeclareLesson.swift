//
//  DeclareLesson.swift
//  TimeTableFirstTry
//
//  Created by Aurel Feer on 05.11.15.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import Foundation

class DeclareLesson {
    func getNewLesson(let day: Int,let pos: Int) -> Lesson {
        let alesson = Lesson(subject: "M", teacher: "Kl", room: "8D", status: .Replaced, day: .Monday, lessonposition: 1, subsubject: "SH", subteacher: "Sc", subroom: "C")
        return alesson
    }

}