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
        //let URLforRequest = "https://oauth.tam.ch/signin/klw-stupla-app?response_type=token&client_id=0Wv69s7vyidj3cKzNckhiSulA5on8uFM&redirect_uri=uniapp%3A%2F%2Fklw-stupla-app&_blank&scope=all"
        
        //UIApplication.sharedApplication().openURL(NSURL(string: URLforRequest)!)
        //let TTCVC = TTCollectionViewController()
        //TTCVC.showLogin()
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
        
        tokenStorage.storeTokenData(token)
        
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
        let URLBaseRequestString = "https://apistage.tam.ch/klw/data/source/timetable/?mod="
        
        //Adding filters to the request
        
        //Building the array containing the filters
        var array = [String : AnyObject]()
        var arrayPartA = [String : String]()
        arrayPartA["Class"] = "%4g"
        //arrayPartA["Location"] = "3b"
        array["ORDER"] = ["Day ASC", "Location DESC"]
        array["WHERE"] = arrayPartA
        
        var URLFilterString:String = ""
        
        do {
            let filterData = try NSJSONSerialization.dataWithJSONObject(array, options: .PrettyPrinted)
            URLFilterString = filterData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        } catch let error {
            print(error)
        }
        
        //The resource-string for the data with filters
        let URLRequestString = URLBaseRequestString + URLFilterString
        
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
                //print("Contents:")
                //print(array)
                self.checkResponseCode(array)
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
        }
    }
    
    func handleChangeWithNotification(oldData:NSArray,newData:NSArray) {
        
    }
    
}