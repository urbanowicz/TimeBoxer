//
//  TimeLabelTextFormatter.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 10/04/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class TimeLabelTextFormatter: NSObject {
    func formatWithNumberOfSecondsToCountDown(numberOfSecondsToCountDown:Int) -> String {
        var counterCopy = numberOfSecondsToCountDown
        let hours = counterCopy / 3600
        counterCopy = counterCopy % 3600
        let minutes = counterCopy / 60
        counterCopy = counterCopy % 60
        let seconds = counterCopy
        
        var timeText = "\(hours):"
        if minutes == 0 {
            timeText += "00:"
        } else {
            if minutes < 10 {
                timeText += "0"
            }
            timeText += "\(minutes):"
        }
        if seconds == 0 {
            timeText += "00"
        } else {
            if seconds < 10 {
                timeText += "0"
            }
            timeText += "\(seconds)"
        }
        return timeText
    }
}
