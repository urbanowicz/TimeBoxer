//
//  MinutesToStringConverter.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 29/02/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class MinutesToStringConverter: NSObject {
    func convert(minutes:Int) -> String {
        let numberOfMinutesInOneHour = 60
        let numberOfHours = Int(minutes / numberOfMinutesInOneHour)
        let numberOfMinutes = minutes % numberOfMinutesInOneHour
        
        var numberOfMinutesText = ""
        if numberOfMinutes > 0 {
            if numberOfMinutes == 1 {
                numberOfMinutesText = "1 minute"
            } else {
                numberOfMinutesText = "\(numberOfMinutes) minutes"
            }
        }
        var numberOfHoursText = ""
        if numberOfHours > 0 {
            if numberOfHours == 1 {
                numberOfHoursText = "1 hour"
            } else {
                numberOfHoursText = "\(numberOfHours) hours"
            }
        }
        var space = ""
        if numberOfHours > 0 && numberOfMinutes > 0 {
            space = " "
        }
        return numberOfHoursText + space +  numberOfMinutesText
    }
}
