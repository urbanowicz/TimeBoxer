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
        
        let dayDifference = dayDifferenceBetween(now, earlierDate: lastWorkedOn!)
        
        //2. lastWorkedOn is the same day as today
        if dayDifference == 0 {
            
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
        }
        
        //3. One day diference
        if  dayDifference == 1 {
            return "yesterday"
        }
        
        //4. 28 day difference
        if dayDifference < 361 {
            return "\(dayDifference) days ago"
        }
        
        //default case, project is older than 361 days
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        return dateFormatter.stringFromDate(lastWorkedOn!)
    
    }
    
    
    //MARK: Helper functions
    private func dayDifferenceBetween(laterDate: NSDate, earlierDate: NSDate) -> Int {
        let calendar = NSCalendar.currentCalendar()
        let dayDifference =
        calendar.components(NSCalendarUnit.Day, fromDate: earlierDate, toDate: laterDate, options: NSCalendarOptions())
        return dayDifference.day
    }
    
}
