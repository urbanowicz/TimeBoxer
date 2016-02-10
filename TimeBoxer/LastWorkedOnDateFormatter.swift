//
//  LastWorkedOnDateFormatter.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 10/02/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class LastWorkedOnDateFormatter: NSObject {
    func formatLastWorkedOnString(lastWorkedOn: NSDate?) -> String {
        
        //1. lastWokredOn is nil
        if lastWorkedOn == nil {
            return "never"
        }
        
        
        
        
        let now = NSDate()
        
        //error case, lastWorkedOn is in the future
        if now.timeIntervalSinceDate(lastWorkedOn!) < 0 {
            return ""
        }
        
        //2. lastWorkedOn is the same day as today
        if isSameDay(now, date2: lastWorkedOn!) {
            
            let differenceInSeconds = Int(now.timeIntervalSinceDate(lastWorkedOn!))
            let differenceInMinutes = differenceInSeconds / 60
            
            //2a
            if differenceInMinutes == 1 {
                return "1 minute ago"
            }
            
            //2b
            if differenceInMinutes < 60 {
                return "\(differenceInMinutes) minutes ago"
            }
            
            //2c
            if differenceInMinutes == 60 {
                return "1 hour ago"
            }
            
            //2d
            if differenceInMinutes > 60 {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
                dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
                return dateFormatter.stringFromDate(lastWorkedOn!)
            }
        } else {
            
        }
        return ""
    }
    
    private func isSameDay(date1:NSDate, date2:NSDate) -> Bool {
        let comparisonResult = NSCalendar.currentCalendar().compareDate(date1, toDate: date2, toUnitGranularity: NSCalendarUnit.Day)
        return comparisonResult == NSComparisonResult.OrderedSame
    }
    
}
