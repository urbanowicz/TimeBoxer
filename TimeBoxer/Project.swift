//
//  Project.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 27/01/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class Project: NSObject {
    var name:String
    var startDate:NSDate
    var state:ProjectState
    var endDate:NSDate?
    var workChunks = [WorkChunk]()
    
    init(projectName:String, startDate:NSDate) {
        self.name = projectName
        self.startDate = startDate
        self.endDate = nil
        self.state = ProjectState.ACTIVE
    }
}

enum ProjectState{
    case ACTIVE, FINISHED
}


extension NSDate
{
    convenience
    init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let d = dateStringFormatter.dateFromString(dateString)!
        self.init(timeInterval:0, sinceDate:d)
    }
}