//
//  WorkTimeFormatter.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 03/04/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class WorkTimeFormatter: NSObject {
    private let formatter = NSDateFormatter()
    override init() {
        super.init()
        formatter.dateFormat = "h:m:s"
    }
    func format(workTimeInSeconds:Int) -> String {
        let components = NSDateComponents()
        components.second = workTimeInSeconds
        let timeString = formatter.stringFromDate(NSCalendar.currentCalendar().dateFromComponents(components)!)
        let timeStringComponents = timeString.componentsSeparatedByString(":")
        let hours = Int(timeStringComponents[0])
        let minutes = Int(timeStringComponents[1])
        let seconds = Int(timeStringComponents[2])
        var stringToReturn = ""
        
        if hours > 0 {
            if minutes > 0 {
                stringToReturn = "\(hours)h\(minutes)m"
            } else {
                stringToReturn = "\(hours)h"
            }
        } else {
            if minutes > 0 {
                if seconds > 0 {
                    stringToReturn = "\(minutes)m\(seconds)s"
                } else {
                    stringToReturn = "\(minutes)m"
                }
            } else {
                if seconds > 0 {
                    stringToReturn = "\(seconds)s"
                } else {
                    stringToReturn = "0h"
                }
            }
        }
        return stringToReturn
    }
}
