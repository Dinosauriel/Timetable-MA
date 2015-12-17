//
//  NotificationHandler.swift
//  Timetable App
//
//  Created by Lukas Boner on 17.12.15.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import Foundation
import WebKit

class NotificationHandler {
    
    func addNewNotificationToQueue(FireDate fireDate: String, Title title:String, Message message:String) {
        let newNotification:UILocalNotification = UILocalNotification()
        newNotification.timeZone = NSTimeZone.defaultTimeZone()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm dd-MM-yyyy"
        formatter.timeZone = NSTimeZone.localTimeZone()
        
        let datetime = formatter.dateFromString(fireDate)
        
        newNotification.fireDate = datetime
        newNotification.alertTitle = title
        newNotification.alertBody = message
        newNotification.alertAction = nil
        UIApplication.sharedApplication().scheduleLocalNotification(newNotification)
    }
    
    func getCurrentTimeAsString() -> String {
        let newNotification:UILocalNotification = UILocalNotification()
        newNotification.timeZone = NSTimeZone.defaultTimeZone()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm dd-MM-yyyy"
        formatter.timeZone = NSTimeZone.localTimeZone()
        let dateTime = formatter.stringFromDate(NSDate())
        return dateTime
    }
    
}
