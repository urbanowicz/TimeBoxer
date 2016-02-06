//
//  Project.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 27/01/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class Project: NSObject, NSCoding, NSCopying {
    let projectNameKey = "projectNameKey"
    let startDateKey = "startDateKey"
    //let projectStateKey = "projectStateKey"
    let endDateKey = "endDateKey"
    let workChunksKey = "workChunksKey"
    
    var name:String
    var startDate:NSDate
    //var state:ProjectState
    var endDate:NSDate?
    var workChunks = [WorkChunk]()
    
    init(projectName:String, startDate:NSDate) {
        self.name = projectName
        self.startDate = startDate
        self.endDate = nil
    }
    
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey(projectNameKey) as! String
        startDate = aDecoder.decodeObjectForKey(startDateKey) as! NSDate
        endDate = aDecoder.decodeObjectForKey(endDateKey) as? NSDate
        workChunks = aDecoder.decodeObjectForKey(workChunksKey) as! [WorkChunk]
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: projectNameKey)
        aCoder.encodeObject(startDate, forKey: startDateKey)
        //aCoder.encodeObject(state, forKey: projectStateKey)
        aCoder.encodeObject(endDate, forKey: endDateKey)
        aCoder.encodeObject(workChunks, forKey:workChunksKey)
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = Project(projectName: name, startDate: startDate)
        copy.endDate = endDate
        var newWorkChunks = Array<WorkChunk>()
        for workChunk in workChunks {
            newWorkChunks.append(workChunk.copyWithZone(nil) as! WorkChunk)
        }
        return newWorkChunks
    }
    
    //MARK: Stats about the project
    
    func startedOn() -> NSDate {
        return startDate
    }
    
    func daysSinceStart() -> Int {
        let now = NSDate()
        let secondsSinceStart = now.timeIntervalSinceDate(startDate)
        let daysSincesStart = Int(secondsSinceStart / (60 * 60 * 24))
        return daysSincesStart
    }
    
    func totalHours() -> Double {
        var totalSeconds = 0
        for chunk in workChunks {
            totalSeconds += chunk.duration
        }
        let totalHours = Double(totalSeconds) / 3600.0
        return totalHours.roundToPlaces(1)
    }
    
    func averagePaceThisWeek() -> Double {
        return 0.0
    }
    
    func lastWrokedOn() -> NSDate {
        return startDate
    }
}

//MARK: ProjectState
enum ProjectState {
    
    case ACTIVE, FINISHED
}

//MARK: NSDate extension
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

extension Double {
    /// Rounds the double to decimal places value
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}