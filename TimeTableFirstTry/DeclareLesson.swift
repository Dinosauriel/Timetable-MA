//
//  DeclareLesson.swift
//  Timetable App
//
//  Created by Aurel Feer on 05.11.15.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import Foundation

class DeclareLesson {
    
    let dayArray: [String] = Day().generateDayArray(.long, forUI: false)
    let timeArray: [String] = ["07:45:00", "08:35:00", "09:25:00", "10:20:00", "11:10:00", "12:00:00", "12:45:00", "13:35:00", "14:25:00", "15:15:00", "16:05:00", "16:55:00"]
    let eventStartTimeString: String = "00:00:00"
    
    let timeZoneAppendix = "+01:00"
    let dateTimeSeparator = "T"
    
    let emptyUILesson = UILesson(subject: "", teacher: "", room: "", status: .Default, subsubject: "", subteacher: "", subroom: "")
    
    var requestedDay: String!
    var requestedTime: String!
    
    //MARK: IDENTIFIERS:
    let lessonIdentifier: String = "lesson"
    let substituteIdentifier: String = "subst"
    let shiftedIdentifier: String = "shift"
    let roomchangedIdentifier: String = "rmchg"
    let addedIdentifier: String = "add"
    let cancelledIdentifier: String = "cancel"
    let blockIdentifier: String = "block"
    let holidayIdentifier: String = "holiday"
    
    func getNewLessonForUI(sec: Int, item: Int) -> UILesson {
        let storage = TimeTableStorage()
        var requestedUILesson: UILesson = emptyUILesson
        
        requestedDay = dayArray[item - 1]
        requestedTime = timeArray[sec - 1]
        
        let requestedDate = requestedDay + dateTimeSeparator + requestedTime + timeZoneAppendix
        let requestedLessons: [TimeTableData] = storage.getTimeTableDataWithStarttime(requestedDate)
        
        let specialEventDate = requestedDay + dateTimeSeparator + eventStartTimeString + timeZoneAppendix
        let specialEvents: [TimeTableData] = storage.getTimeTableDataWithStarttime(specialEventDate)
        
        if requestedLessons.count == 1 {
            let requestedLesson: TimeTableData = requestedLessons[0]
            //print(requestedLesson.event)
            
            requestedUILesson = UILesson(subject: requestedLesson.subject, teacher: requestedLesson.teacher, room: requestedLesson.location, status: .Default, subsubject: "", subteacher: "", subroom: "")
            
            switch requestedLesson.event {
                case lessonIdentifier:
                    requestedUILesson.status = .Default
                    break
                
                case substituteIdentifier:
                    requestedUILesson.status = .Replaced
                    break
                
                case shiftedIdentifier:
                    requestedUILesson.status = .Cancelled
                    break
                
                case roomchangedIdentifier:
                    requestedUILesson.status = .Replaced
                    break
                
                case addedIdentifier:
                    requestedUILesson.status = .MovedTo
                    break
                
                case cancelledIdentifier:
                    requestedUILesson.status = .Cancelled
                    break
                
                case blockIdentifier:
                    requestedUILesson.status = .Special
                    break
                
                case holidayIdentifier:
                    requestedUILesson.status = .Special
                    break
                
                default:
                    requestedUILesson.status = .Default
                    break
            }
            
        } else if requestedLessons.count > 1 {  //More than one lesson at this Position
            
            let requestedLessonA = requestedLessons[0]
            let requestedLessonB = requestedLessons[1]
            print("A: " + requestedLessonA.event)
            print("B: " + requestedLessonB.event)
            
            if requestedLessonA.event == shiftedIdentifier {
                requestedUILesson = UILesson(subject: requestedLessonB.subject, teacher: requestedLessonB.teacher, room: requestedLessonB.location, status: .Replaced, subsubject: requestedLessonA.subject, subteacher: requestedLessonA.teacher, subroom: requestedLessonA.location)
            } else if requestedLessonB.event == shiftedIdentifier {
                requestedUILesson = UILesson(subject: requestedLessonA.subject, teacher: requestedLessonA.teacher, room: requestedLessonA.location, status: .Replaced, subsubject: requestedLessonB.subject, subteacher: requestedLessonB.teacher, subroom: requestedLessonB.location)
            }
            
            if requestedLessonA.event == blockIdentifier {
                requestedUILesson = UILesson(subject: requestedLessonA.subject, teacher: requestedLessonA.teacher, room: requestedLessonA.location, status: .Special, subsubject: "", subteacher: "", subroom: "")
            }
            
            if requestedLessonB.event == blockIdentifier {
                requestedUILesson = UILesson(subject: requestedLessonB.subject, teacher: requestedLessonB.teacher, room: requestedLessonB.location, status: .Special, subsubject: "", subteacher: "", subroom: "")
            }
            
            
            
        } else if requestedLessons.count == 0 { //No lesson at this Position
            
        }
        
        //Overriding everything if there is a Special Event
        if specialEvents.count >= 1 { //Checking for an event
            let event = specialEvents[0]
            requestedUILesson.status = .Special
            if sec == 1 {
                requestedUILesson.subject = event.subject
                requestedUILesson.room = event.location
                requestedUILesson.teacher = event.teacher
            } else {
                requestedUILesson.subject = ""
                requestedUILesson.room = ""
                requestedUILesson.teacher = ""
            }
            
        }
        
        return requestedUILesson
    }
}