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
        
        //2. lastWorkedOn is the same day as today
        if isSameDay(now, date2: lastWorkedOn!) {
            //2a less than 60 minutes ago
            let differenceInSeconds = Int(now.timeIntervalSinceDate(lastWorkedOn!))
            let differenceInMinutes = differenceInSeconds / 60
            if differenceInMinutes == 1 {
                return "1 minute ago"
            } else  {
                return "\(differenceInMinutes) minutes ago"
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
