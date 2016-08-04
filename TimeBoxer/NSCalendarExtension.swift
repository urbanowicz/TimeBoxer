//
//  NSCalendarExtension.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 27/03/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

extension NSCalendar {
    func createDate(withYear year:Int, month:Int, day:Int) -> NSDate? {
        let components = NSDateComponents()
        components.year = year
        components.month = month
        components.day = day
        
        return self.dateFromComponents(components)
    }
    
    func firstDayOfMonth(forDate date:NSDate) -> NSDate {
        let comps = self.components(NSCalendarUnit.Year.union(NSCalendarUnit.Month).union(NSCalendarUnit.Day), fromDate: date)
        comps.day = 1
        return self.dateFromComponents(comps)!
    }
    
    static func gmtCalendar() -> NSCalendar {
        let calendar = NSCalendar.currentCalendar()
        calendar.timeZone = NSTimeZone(abbreviation: "GMT")!
        return calendar
    }
}
