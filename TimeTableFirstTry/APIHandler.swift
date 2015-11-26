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
    var tokenStorage:TokenStorage!
    
    /**
    Requests a new AuthToken from the API-Authentication-Service by opening a webpage for the user to log in
    */
    func requestNewAuthToken() {
        let URLforRequest = "https://oauth.tam.ch/signin/klw-stupla-app?response_type=token&client_id=0Wv69s7vyidj3cKzNckhiSulA5on8uFM&redirect_uri=uniapp%3A%2F%2Fklw-stupla-app&_blank&scope=all"
        
        UIApplication.sharedApplication().openURL(NSURL(string: URLforRequest)!)
    }
    
    /**
    Handles the response of the Authentication-Service by extracting the token from the URL
    */
    func handleTokenResponse(url : NSURL) {
        //Convert the NSURL to a string
        let URLString = String(url)
        //Extract the token out of the string
        let stringArr = URLString.componentsSeparatedByString("&")
        let tokenArr = stringArr[0].componentsSeparatedByString("=")
        
        //Stores the token in a seperate variable
        token = tokenArr[1]
        print("Retrieved token " + token)
        
        if tokenStorage?.isInitialized() != true {
            tokenStorage = TokenStorage(handler: self)
        }
        
        tokenStorage.storeTokenData(token)
    }
    
    /**
    Requests data from the API by using the token. If there's no token stored the function to request one will be called and this function terminates
    */
    func getDataWithToken() {
        if tokenStorage.isInitialized() != true {
            tokenStorage = TokenStorage(handler: self)
        }
        //Loads the token from the data
        let token:String = tokenStorage.getTokenFromData()
        
        //Checks if the app was able to retrieve a token from the data
        if token == "" {
            requestNewAuthToken()
            return
        }
        //The resource-string for the unfiltered data
        let URLBaseRequestString = "https://apistage.tam.ch/klw/data/source/timetable/?mod="
        
        //The resource-string for the data with filters
        let URLRequestString = URLBaseRequestString
        
        //The URL for the data
        let requestURL = NSURL(string: URLRequestString)
        
        let request = NSMutableURLRequest(URL: requestURL!)
        request.HTTPMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) -> Void in
            do {
                let array:NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
                print("Contents:")
                print(array)
            } catch let myJSONError {
                print(myJSONError)
            }
        })
        
        task.resume()
        
    }
    
    func checkResponseCode(dataDict:NSDictionary) {
        let timeTableStorage:TimeTableStorage = TimeTableStorage()
        
        
        if let code = dataDict["code"] as? Int {
            switch Int(code) {
            case 401: print("Not authenticated"); break;
            case 200: print("Ok");
                if (timeTableStorage.getTimeTableData() != (dataDict["body"] as? NSArray)) && (UIApplication.sharedApplication().applicationState == UIApplicationState.Background) {
                    
                }
                timeTableStorage.storeTimeTableData((dataDict["body"] as? NSArray)!);
                break;
            default: print("default")
            }
        }
    }
    
    func handleChangeWithNotification(oldData:NSArray,newData:NSArray) {
        
    }
    
}