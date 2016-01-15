//
//  GetLesson.swift
//  Timetable App
//
//  Created by Aurel Feer on 15.01.16.
//  Copyright © 2016 Aurel Feer. All rights reserved.
//

import Foundation

class GetLesson {
    let time = TimetableTime()
    let calendar = NSCalendar.currentCalendar()
    
    let targetWeek = 1
    let timetableIdentifier = "timetable"
    let lessonsIdentifier = "lessons"
    
    let numberOfNextLessons = 3
    
    var nextLessons: [[String: AnyObject]]!
    
    func setUpNextLessonsWithTimetable(data: NSMutableDictionary) {
        let lessonPos: [Int] = time.getCurrentLessonCoordinates()
        
        let timetable: NSArray = data[timetableIdentifier] as! NSArray
        print("----------------timetable---------------------------------------")
        print(timetable)
        
        let oneWeek: NSArray = timetable[targetWeek] as! NSArray
        print("----------------oneWeek---------------------------------------")
        print(oneWeek)
        
        let oneDay: NSMutableDictionary = oneWeek[lessonPos[0]] as! NSMutableDictionary
        print("----------------oneDay---------------------------------------")
        print(oneDay)
        
        let allLessonsInOneDay: [[String: AnyObject]] = oneDay[lessonsIdentifier] as! [[String: AnyObject]]
        print("----------------allLessonsInOneDay---------------------------------------")
        print(allLessonsInOneDay)
        
        //for lessonCorrection in 0 ..< numberOfNextLessons {
            self.nextLessons.append(allLessonsInOneDay[3])// as [String: AnyObject])
            print("nextLessons: \(self.nextLessons)")
        //}
        
    }
}