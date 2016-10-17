//
//  Token.swift
//  Timetable App
//
//  Created by Lukas Boner and Aurel Feer on 05.11.15.
//  Copyright © 2015 Aurel Feer and Lukas Boner. All rights reserved.
//

import Foundation
import CoreData

class Token: NSManagedObject {
    
    @NSManaged var tokenVar: String!
    
    class func createInManagedObjectContext(_ moc: NSManagedObjectContext, tokenVar: String) -> Token {
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "Token", into: moc) as! Token
        newItem.tokenVar = tokenVar
        
        return newItem
    }
    
}
