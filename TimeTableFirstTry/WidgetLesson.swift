//
//  WidgetLesson.swift
//  TimeTableFirstTry
//
//  Created by Aurel Feer on 09.11.15.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import Foundation

class WidgetLesson {
    
    let time = TimetableTime()
    
    func getCurrentLessonPos() -> Int {
        // Returns the Lessonposition that is currently active
        let currentTime = time.getCurrentHourAndMinute()
        
        if time.compareNSDateComponentsAtoB(currentTime , b: time.getLessonTime(1, when: "end")) == .earlier {
            
            // If the Time earlier to the ending of the first Lesson, the first Lesson is returned
            return 1
        } else if time.compareNSDateComponentsAtoB(currentTime, b: time.getLessonTime(12, when: "end")) == .later || time.compareNSDateComponentsAtoB(currentTime, b: time.getLessonTime(12, when: "end")) == .equal {
            
            // If the Time is later or equal to the end of the last lesson, Lesson 13 is returned -> next Day should be shown
            return 13
        } else {
            return checkIfEarlier()
        }
    }
    
    func checkIfEarlier() -> Int {
        // Returns LessonPosition of any time in the Timetable
        let currentTime = time.getCurrentHourAndMinute()
        var pos = 1
        
        for (var i = 1; i <= 12; i++) {
            if (time.compareNSDateComponentsAtoB(currentTime, b: time.getLessonTime(i - 1, when: "end")) == .later || time.compareNSDateComponentsAtoB(currentTime, b: time.getLessonTime(i - 1, when: "end")) == .equal) && time.compareNSDateComponentsAtoB(currentTime, b: time.getLessonTime(i, when: "end")) == .earlier {
                pos = 1
            } else {
                continue
            }
        }
        return pos
    }
}