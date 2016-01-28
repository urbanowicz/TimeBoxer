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
    var date:NSDate
    var duration:Int
    
    init(date:NSDate, duration:Int) {
        self.date = date
        self.duration = duration
    }
    
    required init(coder decoder: NSCoder) {
        date = decoder.decodeObjectForKey(dateKey) as! NSDate
        duration = decoder.decodeIntegerForKey(durationKey)
     }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(date, forKey: dateKey)
        aCoder.encodeInteger(duration, forKey: durationKey)
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = WorkChunk(date: date, duration: duration)
        return copy
    }
}
