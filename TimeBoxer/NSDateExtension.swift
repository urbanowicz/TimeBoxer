//
//  NSDateExtension.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 27/03/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

extension NSDate {
    
    func isBefore(anotherDate date:NSDate, granularity:NSCalendarUnit) -> Bool {
        let calendar = NSCalendar.currentCalendar()
        let comparisonResult = calendar.compareDate(self, toDate: date, toUnitGranularity: granularity)
        if comparisonResult == NSComparisonResult.OrderedAscending {
            return true
        } else {
            return false
        }
    }
    
    func isAfter(anotherDate date:NSDate, granularity:NSCalendarUnit) -> Bool {
        let calendar = NSCalendar.currentCalendar()
        let comparisonResult = calendar.compareDate(self, toDate: date, toUnitGranularity: granularity)
        if comparisonResult == NSComparisonResult.OrderedDescending {
            return true
        } else {
            return false
        }
    }
    
    func daysSince(earlierDate:NSDate) ->Int {
        let calendar = NSCalendar.currentCalendar()
        let laterDateNoTimeComponent = dateWithNoTimeComponentFromDate(self)
        let earlierDateNoTimeComponent = dateWithNoTimeComponentFromDate(earlierDate)
        let dayDifference =
        calendar.components(NSCalendarUnit.Day, fromDate: earlierDateNoTimeComponent, toDate: laterDateNoTimeComponent, options: [])
        return dayDifference.day
    }
    
    private func dateWithNoTimeComponentFromDate(date: NSDate) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        var unit = NSCalendarUnit.Year
        unit.unionInPlace(NSCalendarUnit.Month)
        unit.unionInPlace(NSCalendarUnit.Day)
        let components = calendar.components(unit, fromDate: date)
        components.second = 0
        components.minute = 0
        components.hour = 0
        components.nanosecond = 0
        return calendar.dateFromComponents(components)!
    }
}
