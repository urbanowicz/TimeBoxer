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
    let dailyGoalKey = "dailyGoalKey"
    
    var name:String
    var dailyGoalSeconds:Int
    var startDate:NSDate
    //var state:ProjectState
    var endDate:NSDate?
    var workChunks = [WorkChunk]()
    
    init(projectName:String, startDate:NSDate, dailyGoalSeconds:Int) {
        self.name = projectName
        self.startDate = startDate
        self.endDate = nil
        self.dailyGoalSeconds = dailyGoalSeconds
    }
    
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey(projectNameKey) as! String
        startDate = aDecoder.decodeObjectForKey(startDateKey) as! NSDate
        endDate = aDecoder.decodeObjectForKey(endDateKey) as? NSDate
        if let dailyGoal = aDecoder.decodeObjectForKey(dailyGoalKey) as? Int {
            dailyGoalSeconds = dailyGoal
        } else {
            dailyGoalSeconds = 4 * 60 * 60 //4 hours
        }
        workChunks = aDecoder.decodeObjectForKey(workChunksKey) as! [WorkChunk]
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: projectNameKey)
        aCoder.encodeObject(startDate, forKey: startDateKey)
        //aCoder.encodeObject(state, forKey: projectStateKey)
        aCoder.encodeObject(endDate, forKey: endDateKey)
        aCoder.encodeObject(workChunks, forKey:workChunksKey)
        aCoder.encodeObject(dailyGoalSeconds, forKey:dailyGoalKey)
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = Project(projectName: name, startDate: startDate, dailyGoalSeconds: dailyGoalSeconds)
        copy.endDate = endDate
        var newWorkChunks = Array<WorkChunk>()
        for workChunk in workChunks {
            newWorkChunks.append(workChunk.copyWithZone(nil) as! WorkChunk)
        }
        copy.workChunks = newWorkChunks
        return copy
    }
//MARK:Recording work time
    func recordWork(durationInSeconds:Int) {
        let workChunk = WorkChunk(date:NSDate(), durationInSeconds: durationInSeconds)
        workChunks.append(workChunk)
    }
    
//MARK: Stats about the project
    func startedOn() -> NSDate {
        return startDate
    }
    
    func daysSinceStart() -> Int {
        ///returns number of days in the project including today
        let now = NSDate()
        let calendar = NSCalendar.gmtCalendar()
        let dayDifference =
            calendar.components(NSCalendarUnit.Day, fromDate: startDate, toDate: now, options: NSCalendarOptions())
        let daysSinceStart = dayDifference.day + 1 //beacuase I want to include today in the sum
        return daysSinceStart
    }
    
    func totalSeconds() -> Int {
        ///returns the total number of seconds spent woring on the project
        var totalSeconds = 0
        for chunk in workChunks {
            totalSeconds += chunk.duration
        }
        return totalSeconds
    }
    
    func totalSeconds(withDate date:NSDate) -> Int {
        let workChunks = workChunksWithDate(date)
        var total = 0
        for workChunk in workChunks {
            total += workChunk.duration
        }
        return total
    }
    
    func lastWrokedOn() -> NSDate? {
        ///returns the Date and Time that this project was last worked on
        ///or nil if it hasn't been worked on yet
        let mostRecentWorkChunk = workChunks.last
        return mostRecentWorkChunk?.date
    }
    
    func workChunksWithDate(date:NSDate) ->[WorkChunk] {
        let calendar = NSCalendar.gmtCalendar()
        var result = [WorkChunk]()
        var comparisonResult = NSComparisonResult.OrderedDescending
        for i in 0 ..< workChunks.count {
            let workChunkDate = workChunks[i].date
            comparisonResult = calendar.compareDate(workChunkDate, toDate: date, toUnitGranularity: .Day)
            if comparisonResult == NSComparisonResult.OrderedSame {
                result.append(workChunks[i])
            }
            if comparisonResult == NSComparisonResult.OrderedDescending {
                break
            }
            
        }
        return result
    }
}

//MARK: ProjectState
enum ProjectState {
    
    case ACTIVE, FINISHED
}