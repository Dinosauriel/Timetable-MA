//
//  CustomNSDate.swift
//  Timetable App
//
//  Created by Lukas Boner on 18.12.15.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import Foundation
import UIKit

extension NSDate: Comparable {}

public func ==(lhs: NSDate, rhs: NSDate) -> Bool
{
    return lhs.timeIntervalSince1970 == rhs.timeIntervalSince1970
}
public func <(lhs: NSDate, rhs: NSDate) -> Bool
{
    return lhs.timeIntervalSince1970 < rhs.timeIntervalSince1970
}
public func >(lhs: NSDate, rhs: NSDate) -> Bool
{
    return lhs.timeIntervalSince1970 > rhs.timeIntervalSince1970
}
public func <=(lhs: NSDate, rhs: NSDate) -> Bool
{
    return lhs.timeIntervalSince1970 <= rhs.timeIntervalSince1970
}
public func >=(lhs: NSDate, rhs: NSDate) -> Bool
{
    return lhs.timeIntervalSince1970 >= rhs.timeIntervalSince1970
}