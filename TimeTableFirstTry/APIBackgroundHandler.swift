//
//  APIBackgroundHandler.swift
//  Timetable App
//
//  Created by Lukas Boner on 16.12.15.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import Foundation
import WebKit

class APIBackgroundHandler {
    
    // Fetch Background data
    func fetchDataFromBackground(completion: () -> Void) {
        //print("YEYY")
        
        //Testing purpose
        
        let loca:UILocalNotification = UILocalNotification()
        loca.timeZone = NSTimeZone.defaultTimeZone()
        let datetime = NSDate()
        loca.fireDate = datetime
        loca.alertTitle = "Test"
        loca.alertBody = "Testing" + String(NSDate())
        loca.alertAction = nil
        UIApplication.sharedApplication().scheduleLocalNotification(loca)
        //getDataWithToken()
        completion()
    }
    
}