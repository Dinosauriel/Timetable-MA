//
//  TokenResponseHandler.swift
//  Timetable App
//
//  Created by Lukas Boner and Aurel Feer on 16.12.15.
//  Copyright © 2015 Aurel Feer and Lukas Boner. All rights reserved.
//

import Foundation

class TokenResponseHandler {
    let userDefaults = UserDefaults.standard
    let sharedDefaults = UserDefaults(suiteName: "group.lee.labf.timetable")
    
    var token : String!
    var tokenStorage = TokenStorage()
    
    /**
     Handles the response of the Authentication-Service by extracting the token from the URL
     */
    func handleTokenResponse(_ url : URL) {
        //Convert the NSURL to a string
        let URLString = String(describing: url)
        //Extract the token out of the string
        let stringArr = URLString.components(separatedBy: "&")
        let tokenArr = stringArr[0].components(separatedBy: "=")
        
        //Stores the token in a seperate variable
        token = tokenArr[1]
        //Set the bool which says if the token is valid or not to true
        userDefaults.set(true, forKey: "RetrievedNewToken")
        //Store the token for later use
        
        sharedDefaults?.set(token, forKey: "token")
        tokenStorage.storeTokenData(token)
        
    }
    
}
