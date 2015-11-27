//
//  TimeTableData.swift
//  TimeTableFirstTry
//
//  Created by Lukas Boner on 25.11.15.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import Foundation
import CoreData

class TimeTableData: NSManagedObject {
    
    @NSManaged var className:String
    @NSManaged var startTime:String
    @NSManaged var endTime:String
    @NSManaged var location:String
    
    class func createInManagedObjectContext(ManagedObjectContext moc:NSManagedObjectContext, ClassName className:String, StartTime startTime:String, EndTime endTime:String, Location location:String) -> TimeTableData {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("Token", inManagedObjectContext: moc) as! TimeTableData
        newItem.className = className
        newItem.startTime = startTime
        newItem.endTime = endTime
        newItem.location = location
        
        return newItem
    }
    
}