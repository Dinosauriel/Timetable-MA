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
    
    /**
    Requests a new AuthToken from the API-Authentication-Service by opening a webpage for the user to log in
    */
    func requestNewAuthToken() {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://oauth.tam.ch/signin/klw-stupla-app?response_type=token&client_id=0Wv69s7vyidj3cKzNckhiSulA5on8uFM&redirect_uri=uniapp%3A%2F%2Fklw-stupla-app&_blank&scope=all")!)
    }
    
    func tes() {
        
    }
    
}