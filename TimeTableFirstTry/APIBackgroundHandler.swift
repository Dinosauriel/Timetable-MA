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
    let tokenStorage:TokenStorage = TokenStorage()
    
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
    }
    
    func getBackgroundData(completion: () -> Void) {
        
        //Loads the token from the data
        let token:String = tokenStorage.getTokenFromData()
        
        //Checks if the app was able to retrieve a token from the data
        if token == "" {
            tokenIsInvalid()
            completion()
            return
        }
        //The resource-string for the unfiltered data
        let URLBaseRequestString = "https://stage.tam.ch/klw/rest/mobile-timetable/auth/"
        
        //The resource-string for the data with filters
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day,.Month,.Year,.Weekday,.Hour,.Minute,.Second], fromDate: date)
        
        let dayVarShort:String
        switch(components.weekday) {
        case 1: dayVarShort = "Sun"
        case 2: dayVarShort = "Mon"
        case 3: dayVarShort = "Tue"
        case 4: dayVarShort = "Wed"
        case 5: dayVarShort = "Thu"
        case 6: dayVarShort = "Fri"
        case 7: dayVarShort = "Sat"
        default: dayVarShort = "Mon"
        }
        let dayVarDate:String = String(components.day)
        let monthVarShort:String
        switch(components.month) {
        case 1: monthVarShort = "Jan"
        case 2: monthVarShort = "Feb"
        case 3: monthVarShort = "Mar"
        case 4: monthVarShort = "Apr"
        case 5: monthVarShort = "Mai"
        case 6: monthVarShort = "Jun"
        case 7: monthVarShort = "Jul"
        case 8: monthVarShort = "Aug"
        case 9: monthVarShort = "Sep"
        case 10: monthVarShort = "Oct"
        case 11: monthVarShort = "Nov"
        case 12: monthVarShort = "Dec"
        default: monthVarShort = "Jan"
        }
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
                    self.checkResponseCode(dataDict)
                }
            } catch let myJSONError {
                print(myJSONError)
            }
        })
        
        print("Requesting Data...")
        task.resume()
        
    }
    
    func checkResponseCode(dataDict:NSDictionary) {
        let timeTableStorage:TimeTableStorage = TimeTableStorage()
        let keys = dataDict.allKeys
        
        if keys.contains({$0 as! String == "code"}) {
            let code = dataDict["code"] as! Int
            switch Int(code) {
            case 401: print("Not authenticated"); tokenIsInvalid()
            default: print("default")
            }
        } else {
            timeTableStorage.storeTimeTableData(dataDict)
        }
    }
    
}