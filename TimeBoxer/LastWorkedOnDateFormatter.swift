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
            return ""
        }
        
        let now = NSDate()
        
        //error case, lastWorkedOn is in the future
        if now.timeIntervalSinceDate(lastWorkedOn!) < 0 {
            return ""
        }
        
        let dayDifference = dayDifferenceBetween(now, earlierDate: lastWorkedOn!)
        
        //2. lastWorkedOn is the same day as today
        if dayDifference == 0 {
            
            let differenceInSeconds = Int(now.timeIntervalSinceDate(lastWorkedOn!))
            if differenceInSeconds < 60 {
                return "just now"
            }
            let differenceInMinutes = differenceInSeconds / 60
            
            //2a
            if differenceInMinutes == 1 {
                return "1m"
            }
            
            //2b
            if differenceInMinutes < 60 {
                return "\(differenceInMinutes)m"
            }
            
            //2c
            if differenceInMinutes == 60 {
                return "1h"
            }
            
            //2d
            if differenceInMinutes > 60 {
                let dateFormatter = NSDateFormatter()
                dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT")
                dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
                dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
                return dateFormatter.stringFromDate(lastWorkedOn!)
            }
        }
        
        //3. One day diference
        if  dayDifference == 1 {
            return "yesterday"
        }
        
        //default case, project is older than 361 days
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT")
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        return dateFormatter.stringFromDate(lastWorkedOn!)
    
    }
    
    
    //MARK: Helper functions
   private func dayDifferenceBetween(laterDate: NSDate, earlierDate: NSDate) -> Int {
        let calendar = NSCalendar.gmtCalendar()
        
        let earlierStartOfDay = calendar.startOfDayForDate(earlierDate)
        let laterStartOfDay = calendar.startOfDayForDate(laterDate)
        
        let dayDifference =
            calendar.components(NSCalendarUnit.Day, fromDate: earlierStartOfDay, toDate: laterStartOfDay, options: .WrapComponents)
        return dayDifference.day
    }
    
}
