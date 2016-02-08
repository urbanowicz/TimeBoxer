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
//MARK:Recording work time
    func recordWork(duration:Int) {
        let workChunk = WorkChunk(date:NSDate(), duration: duration)
        workChunks.append(workChunk)
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
    
    func totalSeconds() -> Int {
        var totalSeconds = 0
        for chunk in workChunks {
            totalSeconds += chunk.duration
        }
        return totalSeconds
    }
    
    
    func averagePaceLastSevenDays() -> Int {
        ///Returns an average number of seconds worked last seven days
        if workChunks.isEmpty {
            return 0
        }
        
        let calendar = NSCalendar.currentCalendar()
        let now = NSDate()
        let sevenDaysAgo:NSDate =
            calendar.dateByAddingUnit(NSCalendarUnit.Day, value: -7, toDate:now , options: NSCalendarOptions())!
        
        //helper inner funcion
        func isSevenDaysOrLessOld(workChunk: WorkChunk) -> Bool {
            let result = calendar.compareDate(sevenDaysAgo, toDate: workChunk.date, toUnitGranularity: NSCalendarUnit.Day)
            if result == NSComparisonResult.OrderedAscending {
                return true
            }
            return false
        }
        
        var totalSecondsLastSevenDays = 0
        var chunkIndex = workChunks.count - 1
        var lastDate = NSDate()
        while chunkIndex >= 0 && isSevenDaysOrLessOld(workChunks[chunkIndex]) {
            totalSecondsLastSevenDays += workChunks[chunkIndex].duration
            lastDate = workChunks[chunkIndex].date
            chunkIndex--
        }
        
        let daysSinceLastDate = Int(now.timeIntervalSinceDate(lastDate) / (3600 * 24))
        let average = Int(totalSecondsLastSevenDays / (daysSinceLastDate + 1))
        return average
    }
    
    func lastWrokedOn() -> NSDate? {
        let mostRecentWorkChunk = workChunks.last
        return mostRecentWorkChunk?.date
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