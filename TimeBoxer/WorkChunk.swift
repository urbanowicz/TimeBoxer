//
//  WorkChunk.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 28/01/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class WorkChunk: NSObject, NSCoding, NSCopying {
    let dateKey = "dateKey"
    let durationKey = "durationKey"
    let timeZoneKey = "timeZoneKey"
    var date:NSDate
    var timeZone:NSTimeZone
    var duration:Int
    
    init(date:NSDate, timeZone:NSTimeZone, durationInSeconds:Int) {
        self.date = date
        self.timeZone = timeZone
        self.duration = durationInSeconds
    }
    
    required init(coder decoder: NSCoder) {
        date = decoder.decodeObjectForKey(dateKey) as! NSDate
        timeZone = decoder.decodeObjectForKey(timeZoneKey) as! NSTimeZone
        duration = decoder.decodeIntegerForKey(durationKey)
     }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(date, forKey: dateKey)
        aCoder.encodeObject(timeZone, forKey: timeZoneKey)
        aCoder.encodeInteger(duration, forKey: durationKey)
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = WorkChunk(date: date, timeZone: timeZone, durationInSeconds: duration)
        return copy
    }
}
