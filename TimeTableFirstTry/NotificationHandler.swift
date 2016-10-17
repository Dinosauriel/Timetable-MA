//
//  NotificationHandler.swift
//  Timetable App
//
//  Created by Lukas Boner and Aurel Feer on 17.12.15.
//  Copyright © 2015 Aurel Feer and Lukas Boner. All rights reserved.
//

import Foundation
import WebKit

class NotificationHandler {
    
    func addNewNotificationToQueue(FireDate fireDate: String, Title title:String, Message message:String) {
        let newNotification:UILocalNotification = UILocalNotification()
        newNotification.timeZone = TimeZone.current
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm dd-MM-yyyy"
        formatter.timeZone = TimeZone.autoupdatingCurrent
        
        let datetime = formatter.date(from: fireDate)
        
        newNotification.fireDate = datetime
        newNotification.alertTitle = title
        newNotification.alertBody = message
        newNotification.soundName = UILocalNotificationDefaultSoundName
        newNotification.alertAction = nil
        UIApplication.shared.scheduleLocalNotification(newNotification)
    }
    
    func getCurrentTimeAsString() -> String {
        let newNotification:UILocalNotification = UILocalNotification()
        newNotification.timeZone = TimeZone.current
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm dd-MM-yyyy"
        formatter.timeZone = TimeZone.autoupdatingCurrent
        let dateTime = formatter.string(from: Date())
        return dateTime
    }
    
}
