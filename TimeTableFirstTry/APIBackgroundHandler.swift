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
    let urlBuilder:URLBuildingSupport = URLBuildingSupport()
    
    // Fetch Background data
    
    func tokenIsInvalid() {
        let dateTime = notificationHandler.getCurrentTimeAsString()
        notificationHandler.addNewNotificationToQueue(FireDate: dateTime, Title: NSLocalizedString("invalidTokenTitle", comment: "invalidTokenTitle"), Message: NSLocalizedString("invalidTokenBody", comment: "changedNotificationTitle"))
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
        let URLRequestString = urlBuilder.getURLForCurrentDate(token)
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
        let keys = dataDict.allKeys
        
        if keys.contains({$0 as! String == "code"}) {
            let code = dataDict["code"] as! Int
            switch Int(code) {
            case 401: print("Not authenticated"); tokenIsInvalid(); return "failed"
            default: print("default"); return "failed"
            }
        } else {
            return checkForChanges(dataDict)
        }
    }
    
    func checkForChanges(newData:NSDictionary) -> String {
        let timeTableStorage:TimeTableStorage = TimeTableStorage()
        
        let weeks:NSArray = (newData as! [String:AnyObject])["timetable"] as! NSArray
        let weeksCount = weeks.count
        var weeksItr = 0
        
        while weeksItr != weeksCount {
            let week:NSArray = weeks[weeksItr] as! NSArray
            let dayCount = week.count
            var dayItr = 0
            
            while dayItr != dayCount {
                let day:NSDictionary = week[dayItr] as! NSDictionary
                let lessons:NSArray = day["lessons"] as! NSArray
                let lessonCount = lessons.count
                var lessonItr = 0
                
                while lessonItr != lessonCount {
                    let lesson:NSDictionary = lessons[lessonItr] as! NSDictionary
                    let lessonID:Int = lesson["id"] as! Int
                    let oldDataToCompareTo:TimeTableData = timeTableStorage.getTimeTableDataWithID(lessonID)[0]
                    if oldDataToCompareTo.event != lesson["eventType"] as! String {
                        let dateTime = notificationHandler.getCurrentTimeAsString()
                        notificationHandler.addNewNotificationToQueue(FireDate: dateTime, Title: NSLocalizedString("changedNotificationTitle", comment: "changedNotificationTitle"), Message: NSLocalizedString("changedNotificationBody", comment: "changedNotificationBody"))
                    }
                    ++lessonItr
                }
                ++dayItr
            }
            ++weeksItr
        }
        timeTableStorage.storeTimeTableData(newData)
        return "newData"
    }
    
}