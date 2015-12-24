//
//  APIHandler.swift
//  Timetable App
//
//  Created by Lukas Boner and Aurel Feer on 25.11.15.
//  Copyright © 2015 Aurel Feer and Lukas Boner. All rights reserved.
//

import Foundation
import WebKit

class APIHandler {
    
    var token : String!
    var tokenStorage = TokenStorage()
    let urlBuilder:URLBuildingSupport = URLBuildingSupport()
    let userDefaults = NSUserDefaults.standardUserDefaults()
    let timeTable = TTCollectionViewController()
    
    /**
    Requests data from the API by using the token. If there's no token stored the function to request one will be called and this function terminates
    */
    func getDataWithToken() {
        userDefaults.setBool(true, forKey: "isSaving")
        //Loads the token from the data
        let token:String = tokenStorage.getTokenFromData()
        print("Got token from data: " + token)
        
        //Checks if the app was able to retrieve a token from the data
        if token == "" {
            userDefaults.setBool(false, forKey: "RetrievedNewToken")
            return
        }
        
        let URLRequestString = urlBuilder.getURLForCurrentDate(token)
        
        //Creating an NSURL with the string
        let requestURL = NSURL(string: URLRequestString)
        //Creating a URLRequest and setting the parameters for it
        let request = NSMutableURLRequest(URL: requestURL!)
        request.HTTPMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        //Creating and configuring the NSURLSessionDataTask which actually requests the data. The block-argument is excecuted when the DataTask is completed
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) -> Void in
            do {
                //The response contains two round brackets which have to be cut off
                
                //The response gets parsed into a string
                if let s:NSString = String(data: data!, encoding: NSUTF8StringEncoding) {
                    var cleaned:String = s as String
                    //The round brackets are cut away
                    cleaned = s.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "()"))
                    //The string gets parsed into data which gets then parsed into a NSMutableDictionary
                    let cleanedData = (cleaned as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                    let dataDict:NSMutableDictionary = try NSJSONSerialization.JSONObjectWithData(cleanedData!, options: NSJSONReadingOptions.MutableContainers) as! NSMutableDictionary
                    
                    self.checkResponseCode(dataDict)
                }
            } catch let myJSONError {
                //In the case that the parsing of the data fails print the error
                //(Never happened until now)
                print(myJSONError)
            }
        })
        
        print("Requesting Data...")
        task.resume()
    }
    
    /**
    This function checks if the response we got contains data we need or if the token was not valid and the API returned code 401
    */
    func checkResponseCode(dataDict:NSDictionary) {
        let timeTableStorage:TimeTableStorage = TimeTableStorage()
        let keys = dataDict.allKeys
        
        if keys.contains({$0 as! String == "code"}) {
            let code = dataDict["code"] as! Int
            switch Int(code) {
                //If the response was a code 401 we have to request a new token
            case 401: print("Not authenticated"); userDefaults.setBool(false, forKey: "RetrievedNewToken")
            default: print("default")
            }
        } else {
            //The data was ok -> store it
            timeTableStorage.storeTimeTableData(dataDict)
        }
    }
    
}