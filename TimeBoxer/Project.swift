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
    let startDateTimeZoneKey = "startDateTimeZoneKey"
    //let projectStateKey = "projectStateKey"
    let endDateKey = "endDateKey"
    let workChunksKey = "workChunksKey"
    let dailyGoalKey = "dailyGoalKey"
    
    var name:String
    var dailyGoalSeconds:Int
    var startDate:NSDate
    var startDateTimeZone:NSTimeZone
    //var state:ProjectState
    var endDate:NSDate?
    var workChunks = [WorkChunk]()
    
    init(projectName:String, dailyGoalSeconds:Int) {
        self.name = projectName
        self.startDate = NSDate()
        self.startDateTimeZone = NSCalendar.currentCalendar().timeZone
        self.endDate = nil
        self.dailyGoalSeconds = dailyGoalSeconds
    }
    
    init(projectName:String, startDate:NSDate, startDateTimeZone:NSTimeZone, dailyGoalSeconds:Int) {
        self.name = projectName
        self.startDate = startDate
        self.startDateTimeZone = startDateTimeZone
        self.endDate = nil
        self.dailyGoalSeconds = dailyGoalSeconds
    }
    
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey(projectNameKey) as! String
        startDate = aDecoder.decodeObjectForKey(startDateKey) as! NSDate
        startDateTimeZone = aDecoder.decodeObjectForKey(startDateTimeZoneKey) as! NSTimeZone
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
        aCoder.encodeObject(startDateTimeZone, forKey: startDateTimeZoneKey)
        //aCoder.encodeObject(state, forKey: projectStateKey)
        aCoder.encodeObject(endDate, forKey: endDateKey)
        aCoder.encodeObject(workChunks, forKey:workChunksKey)
        aCoder.encodeObject(dailyGoalSeconds, forKey:dailyGoalKey)
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = Project(projectName: name, startDate: startDate,startDateTimeZone: startDateTimeZone ,dailyGoalSeconds: dailyGoalSeconds)
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
        let localCalendar = NSCalendar.currentCalendar()
        let workChunk = WorkChunk(date:NSDate(), timeZone: localCalendar.timeZone, durationInSeconds: durationInSeconds)
        workChunks.append(workChunk)
    }
    
//MARK: Stats about the project
    func startedOn() -> NSDate {
        return startDate
    }
    
    func totalSeconds() -> Int {
        ///returns the total number of seconds spent woring on the project
        var totalSeconds = 0
        for chunk in workChunks {
            totalSeconds += chunk.duration
        }
        return totalSeconds
    }
    
    func totalSeconds(year: Int, month: Int, day: Int) -> Int {
        let workChunks = workChunksWithDate(year, month: month, day: day)
        var total = 0
        for workChunk in workChunks {
            total += workChunk.duration
        }
        return total
    }
    
    
    func workChunksWithDate(year: Int, month: Int, day: Int) ->[WorkChunk] {
        var result = [WorkChunk]()
        for i in 0 ..< workChunks.count {
            let workChunkDate = workChunks[i].date
            let timeZone = workChunks[i].timeZone
            let calendar = NSCalendar.currentCalendar()
            calendar.timeZone = timeZone
            let comps = calendar.components(NSCalendarUnit.Year.union(.Month).union(.Day), fromDate: workChunkDate)
            if comps.year == year && comps.month == month && comps.day == day {
                result.append(workChunks[i])
            }
            var shouldStop = false
            if comps.year > year {
                shouldStop = true
            } else {
                if comps.year < year {
                    shouldStop = false
                } else {
                    //same year
                    if comps.month > month {
                        shouldStop = true
                    } else {
                        if comps.month < month {
                            shouldStop = false
                        } else {
                            //same year and month 
                            if comps.day > day {
                                shouldStop = true
                            } else {
                                shouldStop = false
                            }
                        }
                    }
                }
            }
            if shouldStop {
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
