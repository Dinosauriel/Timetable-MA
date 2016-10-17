//
//  APIBackgroundHandler.swift
//  Timetable App
//
//  Created by Lukas Boner and Aurel Feer on 16.12.15.
//  Copyright © 2015 Aurel Feer and Lukas Boner. All rights reserved.
//

import Foundation
import WebKit

class APIBackgroundHandler {
    
    var notificationHandler:NotificationHandler = NotificationHandler()
    var UserDefaults = Foundation.UserDefaults.standard
    let tokenStorage:TokenStorage = TokenStorage()
    let urlBuilder:URLBuildingSupport = URLBuildingSupport()
    let timeTableStorage = TimeTableStorage()
    
    // Fetch Background data
    
    func tokenIsInvalid() {
        let dateTime = notificationHandler.getCurrentTimeAsString()
        notificationHandler.addNewNotificationToQueue(FireDate: dateTime, Title: NSLocalizedString("invalidTokenTitle", comment: "invalidTokenTitle"), Message: NSLocalizedString("invalidTokenBody", comment: "changedNotificationTitle"))
        UserDefaults.set(false, forKey: "RetrievedNewToken")
    }
    
    func getBackgroundData(_ completion: @escaping (String) -> Void) {
        UserDefaults.set(true, forKey: "isSaving")
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
        let requestURL = URL(string: URLRequestString)
        
        let request = NSMutableURLRequest(url: requestURL!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
            do {
                print("Contents:")
                if let s:NSString = String(data: data!, encoding: String.Encoding.utf8) {
                    var cleaned:String
                    cleaned = s.trimmingCharacters(in: CharacterSet(charactersIn: "()"))
                    let cleanedData = (cleaned as NSString).data(using: String.Encoding.utf8)
                    let dataDict:NSMutableDictionary = try JSONSerialization.jsonObject(with: cleanedData!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableDictionary
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
    
    func checkResponseCode(_ dataDict:NSDictionary) -> String {
        let keys = dataDict.allKeys
        
        if keys.contains(where: {$0 as! String == "code"}) {
            let code = dataDict["code"] as! Int
            switch Int(code) {
            case 401: print("Not authenticated"); tokenIsInvalid(); return "failed"
            default: print("default"); return "failed"
            }
        } else {
            let returnString = checkForChanges(dataDict)
            if returnString == "newData" {
                timeTableStorage.storeTimeTableData(dataDict)
            }
            return returnString
        }
    }
    
    func checkForChanges(_ newData:NSDictionary) -> String {
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
                    let oldDataToCompareToArray:NSArray = timeTableStorage.getTimeTableDataWithTimeString(lesson["start"] as! String)
                    if oldDataToCompareToArray.count != 0 {
                        let oldDataToCompareTo:TimeTableData = oldDataToCompareToArray[0] as! TimeTableData
                        if oldDataToCompareTo.event != lesson["eventType"] as! String {
                            print("changed")
                            let dateTime = notificationHandler.getCurrentTimeAsString()
                            notificationHandler.addNewNotificationToQueue(FireDate: dateTime, Title: NSLocalizedString("changedNotificationTitle", comment: "changedNotificationTitle"), Message: NSLocalizedString("changedNotificationBody", comment: "changedNotificationBody"))
                            return "newData"
                        }
                    }
                    lessonItr += 1
                }
                dayItr += 1
            }
            weeksItr += 1
        }
return "noData"
    }
    
}
