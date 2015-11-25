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
    let tokenStorage:TokenStorage = TokenStorage()
    
    /**
    Requests a new AuthToken from the API-Authentication-Service by opening a webpage for the user to log in
    */
    func requestNewAuthToken() {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://oauth.tam.ch/signin/klw-stupla-app?response_type=token&client_id=0Wv69s7vyidj3cKzNckhiSulA5on8uFM&redirect_uri=uniapp%3A%2F%2Fklw-stupla-app&_blank&scope=all")!)
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
        tokenStorage.storeTokenData(token)
    }
    
    func getDataWithToken() {
        let token:String = tokenStorage.getTokenFromData()
        
        if token == "" {
            requestNewAuthToken()
            return
        }
        
        let URLRequestString = "https://apistage.tam.ch/klw/data/source/timetable"
        
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
        if let code = dataDict["code"] as? Int {
            switch Int(code) {
            case 401: print("Not authenticated"); break;
            case 200: print("Ok"); break;
            default: print("default")
            }
        }
    }
    
}