//
//  TokenStorage.swift
//  Timetable App
//
//  Created by Lukas Boner and Aurel Feer on 25.11.15.
//  Copyright © 2015 Aurel Feer and Lukas Boner. All rights reserved.
//

import Foundation
import WebKit
import CoreData

class TokenStorage {
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    func storeTokenData(_ token : String) {
        let fetchRequest = NSFetchRequest(entityName: "Token")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedObjectContext?.execute(deleteRequest)
        } catch let error as NSError {
            print(error)
        }
        
        //Saves the token to the local storage for later use
        if let moc = self.managedObjectContext {
            Token.createInManagedObjectContext(moc, tokenVar: token)
        }
        
        //Writing to the file in case of interruption (XCode-Stop)
        do {
            try managedObjectContext?.save()
            print("Token saved")
            let apiHandler:APIHandler = APIHandler()
            apiHandler.getDataWithToken()
        } catch let error {
            print(error)
        }

    }
    
    func getTokenFromData() -> String {
        var token:String = ""
        //Create a fetchRequest for the entity in which the token is saved
        let fetchRequest = NSFetchRequest(entityName: "Token")
        
        //Tries to read the token from the storage and stores it in the "token"-variable if possible
        if let fetchResults = try! managedObjectContext?.fetch(fetchRequest) as? [Token] {
            if fetchResults.count != 0 {
                if fetchResults.count == 1 {
                    token = fetchResults[0].tokenVar
                    print("Got token from data")
                    return token
                } else {
                    return ""
                }
            } else {
                print("No token")
                return ""
            }
        } else {
            print("Error")
            return ""
        }
    }
    
}
