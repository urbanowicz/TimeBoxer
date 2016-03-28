//
//  NSCalendarExtension.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 27/03/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

extension NSCalendar {
    public func mondayBeforeTheDate(date:NSDate) -> NSDate {
        let components = self.components([NSCalendarUnit.Weekday], fromDate:date)
        let numberOfDaysSinceMonday = components.weekday - 2
        let monday = self.dateByAddingUnit(NSCalendarUnit.Day, value: -numberOfDaysSinceMonday, toDate: date, options: NSCalendarOptions.WrapComponents)!
        return monday
    }
    
    func dateToWeek(date:NSDate) -> [NSDate] {
        let components = self.components([NSCalendarUnit.Weekday], fromDate:date)
        let numberOfDaysSinceMonday = components.weekday - 2
        let monday = self.dateByAddingUnit(NSCalendarUnit.Day, value: -numberOfDaysSinceMonday, toDate: date, options: NSCalendarOptions.WrapComponents)!
        var week = [monday]
        for i in 1 ... 6 {
            week.append(self.dateByAddingUnit(NSCalendarUnit.Day, value: i, toDate: monday, options: NSCalendarOptions.WrapComponents)!)
        }
        return week
    }
}
