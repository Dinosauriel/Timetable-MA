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
    
    var token:NSString!
    
let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    func requestAuthToken() {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://oauth.tam.ch/signin/klw-stupla-app?response_type=token&client_id=0Wv69s7vyidj3cKzNckhiSulA5on8uFM&redirect_uri=uniapp%3A%2F%2Fklw-stupla-app&_blank&scope=all")!)
    }
    
    func handleTokenResponse(url : NSURL) {
        
        let URLstring = String(url)
        let stringArr = URLstring.componentsSeparatedByString("&")
        let tokenArr = stringArr[0].componentsSeparatedByString("=")
        
        token = tokenArr[1]

        if let moc = self.managedObjectContext {
            Token.createInManagedObjectContext(moc, tokenVar: tokenArr[1])
        }
    }
    
    func getDataWithToken(token : NSString) -> NSString {
        
        var contents:NSString
        contents = ""
        
        let tableURL = NSURL(string: "https://apistage.tam.ch/klw/data/source/timetable") //https://cloudfs.tam.ch/api/v1/collection/children
        
        let request = NSMutableURLRequest(URL: tableURL!)
        request.HTTPMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.currentQueue()!) { response, maybeData, error in
            if let data = maybeData {
                contents = NSString(data:data, encoding:NSUTF8StringEncoding)!
            } else {
                print(error!.localizedDescription)
            }
        }
        
        if contents != "" {
            return contents
        } else {
            return ""
        }
    }
    
    func getTokenFromData() -> Bool {
        
        let fetchRequest = NSFetchRequest(entityName: "Token")
        
        if let fetchResults = try! managedObjectContext?.executeFetchRequest(fetchRequest) as? [Token] {
            
            if fetchResults.count != 0 {
                print(fetchResults[0])
            
                token = fetchResults[0].tokenVar
            
                return true
            } else {
                return false
            }
            
        } else {
            return false
        }
    }
}