//
//  GetAPIData.swift
//  TimeTableFirstTry
//
//  Created by Lukas Boner on 03.11.15.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import Foundation
import WebKit
import CoreData

class GetAPIData {
    //Stores the token
    var token:NSString!
    var timeData:NSArray!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    //Requests a new token and opens a browser for the user to authenticate
    func requestAuthToken() {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://oauth.tam.ch/signin/klw-stupla-app?response_type=token&client_id=0Wv69s7vyidj3cKzNckhiSulA5on8uFM&redirect_uri=uniapp%3A%2F%2Fklw-stupla-app&_blank&scope=all")!)
    }
    
    //Handles the response of the authentification-server and saves it to the local storage
    func handleTokenResponse(url : NSURL) {
        //Convert the NSURL to a string
        let URLstring = String(url)
        //Extract the token out of the string
        let stringArr = URLstring.componentsSeparatedByString("&")
        let tokenArr = stringArr[0].componentsSeparatedByString("=")
        
        //Stores the token in a seperate variable
        token = tokenArr[1]
        print("Token: " + String(token))
        print(String(url))
        let fetchRequest = NSFetchRequest(entityName: "Token")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedObjectContext?.executeRequest(deleteRequest)
        } catch let error as NSError {
            print(error)
        }
        
        //Saves the token to the local storage for later use
        if let moc = self.managedObjectContext {
            Token.createInManagedObjectContext(moc, tokenVar: tokenArr[1])
        }
        
        //Writing to the file in case of interruption (XCode-Stop)
        do {
            try managedObjectContext?.save()
            print("Saved")
        } catch let error {
            print(error)
        }
        
        
        getDataWithToken()
    }
    
    //Requests the data with the token and returns it as a NSString
    func getDataWithToken() {
        
        //Checks if the token is available and loaded
        if token == nil || token == "" {
            getTokenFromData()
        }
        
        /*
        let json: JSON = ["WHERE":["Class":"%3f", "Location":"3b"], "ORDER":["Day ASC", "Loaction DESC"]]
        
        let utf8Str = json.rawString()?.dataUsingEncoding(NSUTF8StringEncoding)
        
        let encodedStr = utf8Str?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        print(json)
        
        let str = "eyJXSEVSRSI6eyJDbGFzcyI6IiUzZiIsIkxvY2F0aW9uIjoiM2IifSwiT1JERVIiOlsiRGF5IEFTQyIsIkxvY2F0aW9uIERFU0MiXX0="
        
        let datad = NSData(base64EncodedString: str, options: NSDataBase64DecodingOptions(rawValue: 0))
        
        do {
            let result = try NSJSONSerialization.JSONObjectWithData(datad!, options: .AllowFragments)
            print(result)
        } catch let error {
            print(error)
        }
        print("Own")
        print(encodedStr)*/
        
        //{"WHERE":{"Class":"%3f","Location":"3b"},"ORDER":["Day ASC","Location DESC"]}
        //+ "/?mod=" + encodedStr!
        //Creates the NSURL pointing to the data on the server
        let URLString = "https://api.tam.ch/klw/data/source/timetable" + "/?mod=eyJXSEVSRSI6eyJDbGFzcyI6IiUzZiIsIkxvY2F0aW9uIjoiM2IifSwiT1JERVIiOlsiRGF5IEFTQyIsIkxvY2F0aW9uIERFU0MiXX0="
        
        let tableURL = NSURL(string: URLString) //https://cloudfs.tam.ch/api/v1/collection/children https://apistage.tam.ch/klw/data/source/timetable
        
        let request = NSMutableURLRequest(URL: tableURL!)
        request.HTTPMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) -> Void in
            do {
                let array:NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
                self.handleDataResponse(array)
                print("Contents:")
                print(array)
            } catch let myJSONError {
                print(myJSONError)
            }
        })
        
        task.resume()
        
    }
    // Fetch Background data
    func fetchDataFromBackground(completion: () -> Void) {
        //print("YEYY")
        
        //Testing purpose
        /*
        var loca:UILocalNotification = UILocalNotification()
        loca.timeZone = NSTimeZone.defaultTimeZone()
        var datetime = NSDate()
        loca.fireDate = datetime
        loca.alertTitle = "Test"
        loca.alertBody = "Testing" + String(NSDate())
        loca.alertAction = nil
        UIApplication.sharedApplication().scheduleLocalNotification(loca)*/
        //getDataWithToken()
        completion()
    }
    
    func handleDataResponse(dataDict:NSDictionary) {
        if let code = dataDict["code"] as? Int {
            switch Int(code) {
            case 401: print("Not authenticated"); requestAuthToken(); break;
            case 200: print("Ok"); if let timeData = dataDict["body"]{}; break;
            default: print("default")
            }
        }
    }
    
    //Retrieves the stored token from the storage and returns false if it failed or in case of success true
    func getTokenFromData() -> Bool {
        //Create a fetchRequest for the entity in which the token is saved
        let fetchRequest = NSFetchRequest(entityName: "Token")
        
        //Tries to read the token from the storage and stores it in the "token"-variable if possible
        if let fetchResults = try! managedObjectContext?.executeFetchRequest(fetchRequest) as? [Token] {
            if fetchResults.count != 0 {
                if fetchResults.count == 1 {
                    token = fetchResults[0].tokenVar
                    print("Got token from data")
//                    print(fetchResults.count)
                    print(token)
                } else {
                    requestAuthToken()
                }
                return true
            } else {
                print("No token")
                return false
            }
        } else {
            print("Error")
            return false
        }
    }
    
    func getTimeData() -> NSArray {
        return timeData
    }
    
    //Returns the token-variable
    func getToken() -> NSString {
        if token != nil && token != "" {
            return token
        } else {
            getTokenFromData()
            return token
        }
    }
}