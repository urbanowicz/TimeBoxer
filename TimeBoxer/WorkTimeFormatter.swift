//
//  WorkTimeFormatter.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 03/04/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class WorkTimeFormatter: NSObject {

    func format(workTimeInSeconds:Int) -> String {
        let hours:Int = workTimeInSeconds / 3600
        let minutes:Int = (workTimeInSeconds % 3600) / 60
        let seconds:Int = (workTimeInSeconds % 3600) % 60
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
