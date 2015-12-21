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
    
    @NSManaged var nameOfClass:String
    @NSManaged var startTime:String
    @NSManaged var endTime:String
    @NSManaged var location:String
    @NSManaged var subject:String
    @NSManaged var teacher:String
    @NSManaged var day:String
    @NSManaged var event:String
    @NSManaged var id:Int64
    
    class func createInManagedObjectContext(ManagedObjectContext moc:NSManagedObjectContext, ClassName className:String, StartTime startTime:String, EndTime endTime:String, Location location:String, Subject subject:String, Teacher teacher:String, Day day:String, Event event:String, ID id:Int64) -> TimeTableData {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("TimeTableData", inManagedObjectContext: moc) as! TimeTableData
        newItem.nameOfClass = className
        newItem.startTime = startTime
        newItem.endTime = endTime
        newItem.location = location
        newItem.subject = subject
        newItem.teacher = teacher
        newItem.day = day
        newItem.event = event
        newItem.id = id
        
        return newItem
    }
    
}