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
    
    var notificationHandler:NotificationHandler = NotificationHandler()
    var UserDefaults = NSUserDefaults.standardUserDefaults()
    let tokenStorage:TokenStorage = TokenStorage()
    let shortName:ShortNameForDayMonth = ShortNameForDayMonth()
    
    // Fetch Background data
    func fetchDataFromBackground(completion: () -> Void) {
        let dateTime = notificationHandler.getCurrentTimeAsString()
        notificationHandler.addNewNotificationToQueue(FireDate: dateTime, Title: "Fetch", Message: "Fetched data from Background!")
        
        //getDataWithToken()
        completion()
    }
    
    func tokenIsInvalid() {
        let dateTime = notificationHandler.getCurrentTimeAsString()
        notificationHandler.addNewNotificationToQueue(FireDate: dateTime, Title: "Token is invalid", Message: "The token has expired or is not valid. Please log in retrieve a new one.")
        UserDefaults.setBool(false, forKey: "RetrievedNewToken")
    }
    
    func getBackgroundData(completion: (String) -> Void) {
        
        //Loads the token from the data
        let token:String = tokenStorage.getTokenFromData()
        
        //Checks if the app was able to retrieve a token from the data
        if token == "" {
            tokenIsInvalid()
            completion("failed")
            return
        }
        //The resource-string for the unfiltered data
        let URLBaseRequestString = "https://stage.tam.ch/klw/rest/mobile-timetable/auth/"
        
        //The resource-string for the data with filters
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day,.Month,.Year,.Weekday,.Hour,.Minute,.Second], fromDate: date)
        
        let dayVarShort:String = shortName.day(components.day)
        let dayVarDate:String = String(components.day)
        let monthVarShort:String = shortName.month(components.month)
        let yearVar:String = String(components.year)
        let hourVar:String = String(components.hour)
        let minuteVar:String = String(components.minute)
        let secondVar:String = String(components.second)
        let timeZoneVar:String = "GMT"//String(NSTimeZone.localTimeZone())
        
        
        let URLRequestString = URLBaseRequestString + token + "/date/" + dayVarShort + "%2C%20" + dayVarDate + "%20" + monthVarShort + "%20" + yearVar + "%20" + hourVar + "%3A" + minuteVar + "%3A" + secondVar + "%20" + timeZoneVar
        print(URLRequestString)
        //The URL for the data
        let requestURL = NSURL(string: URLRequestString)
        
        let request = NSMutableURLRequest(URL: requestURL!)
        request.HTTPMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) -> Void in
            do {
                print("Contents:")
                if let s:NSString = String(data: data!, encoding: NSUTF8StringEncoding) {
                    var cleaned:String
                    cleaned = s.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "()"))
                    let cleanedData = (cleaned as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                    let dataDict:NSMutableDictionary = try NSJSONSerialization.JSONObjectWithData(cleanedData!, options: NSJSONReadingOptions.MutableContainers) as! NSMutableDictionary
                    print("Received Data")
                    completion(self.checkResponseCode(dataDict))
                }
            } catch let myJSONError {
                print(myJSONError)
            }
        })
        
        print("Requesting Data...")
        task.resume()
        
    }
    
    func checkResponseCode(dataDict:NSDictionary) -> String {
        let timeTableStorage:TimeTableStorage = TimeTableStorage()
        let keys = dataDict.allKeys
        
        if keys.contains({$0 as! String == "code"}) {
            let code = dataDict["code"] as! Int
            switch Int(code) {
            case 401: print("Not authenticated"); tokenIsInvalid(); return "failed"
            default: print("default"); return "failed"
            }
        } else {
            timeTableStorage.storeTimeTableData(dataDict)
            let dateTime = notificationHandler.getCurrentTimeAsString()
            notificationHandler.addNewNotificationToQueue(FireDate: dateTime, Title: "New Data", Message: "New data!")
            return "newData"
        }
    }
    
    func checkForChanges(newData:NSDictionary) {
        let timeTableStorage:TimeTableStorage = TimeTableStorage()
        
        let oldData:NSArray = timeTableStorage.getTimeTableData()
        let changedLessons:NSMutableArray = []
        let newLessons:NSMutableArray = []
        
        for newWeek in newData["timeTable"] as! [NSArray] {
            for newDay:NSDictionary in newWeek as! [NSDictionary] {
                let lessons:NSArray = newDay["lessons"] as! NSArray
                for lesson:NSDictionary in lessons as! [NSDictionary] {
                    newLessons.addObject(lesson)
                    for oldLesson:TimeTableData in oldData as! [TimeTableData] {
                        if changedLessons.containsObject(NSNumber(longLong: oldLesson.id)) {
                            break
                        }
                        if oldLesson.id == lesson["id"] as! Int64 {
                            if oldLesson.event != lesson["eventType"] as! String {
                                changedLessons.addObject(lesson)
                                break
                            }
                        }
                    }
                }
            }
        }
        
        let lessonsToCheck:NSMutableArray = []
        
        for lesson:NSDictionary in newLessons as! [NSDictionary] {
            let dateFormatter:NSDateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            var startString:String = lesson["start"]! as! String
            startString = startString.stringByReplacingOccurrencesOfString("T", withString: " ")
            startString = startString.stringByReplacingOccurrencesOfString("+", withString: " +")
            let startDate = dateFormatter.dateFromString(startString)
            
            var endString:String = lesson["start"]! as! String
            endString = endString.stringByReplacingOccurrencesOfString("T", withString: " ")
            endString = endString.stringByReplacingOccurrencesOfString("+", withString: " +")
            let endDate = dateFormatter.dateFromString(endString)
            
            
            
        }
        
    }
    
}