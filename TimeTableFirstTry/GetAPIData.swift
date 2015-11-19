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
        print(token)
        //Saves the token to the local storage for later use
        if let moc = self.managedObjectContext {
            Token.createInManagedObjectContext(moc, tokenVar: tokenArr[1])
        }
        getDataWithToken()
    }
    
    //Requests the data with the token and returns it as a NSString
    func getDataWithToken() {
        
        //Creates the variable in which the returned data is stored
        var contents:NSString
        contents = ""
        
        //Checks if the token is available and loaded
        if token == nil || token == "" {
            getTokenFromData()
        }
        
        //Creates the NSURL pointing to the data on the server
        let tableURL = NSURL(string: "https://apistage.tam.ch/klw/data/source/timetable") //https://cloudfs.tam.ch/api/v1/collection/children
        
        let request = NSMutableURLRequest(URL: tableURL!)
        request.HTTPMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            contents = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            print(contents)
        })
        
        task.resume()
    }
    
    //Retrieves the stored token from the storage and returns false if it failed or in case of success true
    func getTokenFromData() -> Bool {
        //Create a fetchRequest for the entity in which the token is saved
        let fetchRequest = NSFetchRequest(entityName: "Token")
        
        //Tries to read the token from the storage and stores it in the "token"-variable if possible
        if let fetchResults = try! managedObjectContext?.executeFetchRequest(fetchRequest) as? [Token] {
            if fetchResults.count != 0 {
            
                token = fetchResults[0].tokenVar
                return true
            } else {
                return false
            }
        } else {
            return false
        }
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