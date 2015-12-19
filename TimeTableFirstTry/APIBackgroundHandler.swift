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
                    var cleaned:String = s as String
                    print(s)
                    
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
        
        //let oldData: NSDictionary = timeTableStorage.getTimeTableDict()
        
        for newWeek in newData["timeTable"] as! [NSArray] {
            for newDay:NSDictionary in newWeek as! [NSDictionary] {
                let newDayDate:String = newDay["date"] as! String
                let lessons:NSArray = newDay["lessons"] as! NSArray
                for lesson:NSDictionary in lessons as! [NSDictionary] {
                    
                }
            }
        }
    }
    
}