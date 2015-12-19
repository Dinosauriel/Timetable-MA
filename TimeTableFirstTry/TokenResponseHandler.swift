//
//  TokenResponseHandler.swift
//  Timetable App
//
//  Created by Lukas Boner on 16.12.15.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import Foundation

class TokenResponseHandler {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    var token : String!
    var tokenStorage = TokenStorage()
    
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
        userDefaults.setBool(true, forKey: "RetrievedNewToken")
        tokenStorage.storeTokenData(token)
        
    }
    
}