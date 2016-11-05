//
//  DummyCalendarHeatMapDataSource.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 05/08/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class DummyCalendarHeatMapDataSource: NSObject, CalendarHeatMapDataSource {
    
    func startDate() -> NSDate {
        let formatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone(abbreviation: "GMT")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.dateFromString("2016-07-10")!
    }
    
    func startDateTimeZone() -> NSTimeZone {
        return NSCalendar.currentCalendar().timeZone
    }
    
    func heat(year: Int, month: Int, day: Int) -> CGFloat {
        return CGFloat(arc4random_uniform(100)) / CGFloat(100)
    }
    
    func totalSeconds(year: Int, month: Int, day: Int) -> Int {
        return Int(arc4random_uniform(10800))
    }
}
