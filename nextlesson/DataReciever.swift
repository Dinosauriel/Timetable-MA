//
//  DataReciever.swift
//  Timetable App
//
//  Created by Aurel Feer on 14.01.16.
//  Copyright © 2016 Aurel Feer. All rights reserved.
//

import Foundation

class DataReciever {
    
    let sharedDefaults = NSUserDefaults(suiteName: "group.lee.labf.timetable")
    let urlBuilder:URLBuildingSupport = URLBuildingSupport()
    func getEntireTable() {
        let token:String = (sharedDefaults?.objectForKey("token"))! as! String
        
        let URLRequestString = urlBuilder.getURLForCurrentDate(token)
        
        let requestURL = NSURL(string: URLRequestString)
        let request = NSMutableURLRequest(URL: requestURL!)
        request.HTTPMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) -> Void in
            do {
                if let s:NSString = String(data: data!, encoding: NSUTF8StringEncoding) {
                    var cleaned:String = s as String
                    cleaned = s.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "()"))
                    let cleanedData = (cleaned as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                    let dataDict:NSMutableDictionary = try NSJSONSerialization.JSONObjectWithData(cleanedData!, options: NSJSONReadingOptions.MutableContainers) as! NSMutableDictionary
                    
                    let keys = dataDict.allKeys
                    if !keys.contains({$0 as! String == "code"}) {
                        //success -> call draw function
                    } else {
                        //not successful
                    }
                    
                }
            } catch let myJSONError {
                //In the case that the parsing of the data fails print the error
                //(Never happened until now)
                print(myJSONError)
            }
        })
        task.resume()
    }
    
}