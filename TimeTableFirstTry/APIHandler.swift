//
//  APIHandler.swift
//  TimeTableFirstTry
//
//  Created by Lukas Boner on 25.11.15.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import Foundation
import WebKit

class APIHandler {
    
    var token : String!
    var tokenStorage = TokenStorage()
    
    /**
    Requests a new AuthToken from the API-Authentication-Service by opening a webpage for the user to log in
    */
    func requestNewAuthToken() {
        print("GETTING NEW TOKEN!")
        //NSNotificationCenter.defaultCenter().postNotificationName("NotificationIdentifier", object: nil)
        //let TTCVC = (UIApplication.sharedApplication().delegate as! AppDelegate).getView()
        //TTCVC.performSegueWithIdentifier("showLogin", sender: TTCVC)
    }
    
    /**
    Requests data from the API by using the token. If there's no token stored the function to request one will be called and this function terminates
    */
    func getDataWithToken() {

        //Loads the token from the data
        let token:String = tokenStorage.getTokenFromData()
        
        //Checks if the app was able to retrieve a token from the data
        if token == "" {
            requestNewAuthToken()
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
        //let URLRequestString = "https://stage.tam.ch/klw/rest/mobile-timetable/auth/"+token+"/date/Thu%2C%2010%20Dec%202015%2012%3A53%3A00%20GMT"
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
            case 401: print("Not authenticated"); requestNewAuthToken()
            default: print("default")
            }
        } else {
            timeTableStorage.storeTimeTableData(dataDict)
        }
        
        /*if let code = dataDict["code"] as! Int? {
            switch Int(code) {
            case 401: print("Not authenticated")
            case 200: print("Ok")
                let table = timeTableStorage.getTimeTableData()
                if (table != (dataDict["body"] as? NSArray)) && (UIApplication.sharedApplication().applicationState == UIApplicationState.Background) && (table != []) {
                    
                }
                timeTableStorage.storeTimeTableData(dataDict);
                print(dataDict["body"]![0])
                break;
            default: print("default")
            }
        } else {
            timeTableStorage.storeTimeTableData(dataDict)
        }*/
    }
    
    func handleChangeWithNotification(oldData:NSArray,newData:NSArray) {
        
    }
    
}