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
    let endDateKey = "endDateKey"
    let workChunksKey = "workChunksKey"
    let dailyGoalKey = "dailyGoalKey"
    
    var name:String
    var dailyGoalSeconds:Int
    var startDate:NSDate
    var startDateTimeZone:NSTimeZone
    var endDate:NSDate?
    var workChunks = [String:Int]()
    
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
        workChunks = aDecoder.decodeObjectForKey(workChunksKey) as! [String:Int]
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: projectNameKey)
        aCoder.encodeObject(startDate, forKey: startDateKey)
        aCoder.encodeObject(startDateTimeZone, forKey: startDateTimeZoneKey)
        aCoder.encodeObject(endDate, forKey: endDateKey)
        aCoder.encodeObject(workChunks, forKey:workChunksKey)
        aCoder.encodeObject(dailyGoalSeconds, forKey:dailyGoalKey)
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = Project(projectName: name, startDate: startDate,startDateTimeZone: startDateTimeZone ,dailyGoalSeconds: dailyGoalSeconds)
        copy.endDate = endDate
        copy.workChunks = workChunks
        return copy
    }
//MARK:Recording work time
    
    func recordWork(startTime:NSDate, durationSeconds:Int) {
        let localCalendar = NSCalendar.currentCalendar()
        let comps = localCalendar.components(NSCalendarUnit.Year.union(.Month).union(.Day), fromDate: startTime)
        let dateKey = buildDateKey(comps.year, month: comps.month, day: comps.day)
        if workChunks[dateKey] == nil {
            workChunks[dateKey] = durationSeconds
        } else {
            let currentTotalWorkTime = workChunks[dateKey]!
            workChunks[dateKey] = currentTotalWorkTime + durationSeconds
        }
    }
    
//MARK: Stats about the project
    func startedOn() -> NSDate {
        return startDate
    }
    
    func totalSeconds(year: Int, month: Int, day: Int) -> Int {
        
        let dateKey = buildDateKey(year, month: month, day: day)
        if let total = workChunks[dateKey] {
            return total
        } else {
            return 0
        }
    }
    
    private func buildDateKey(year: Int, month: Int, day: Int) ->String {
        return "\(year)\(month)\(day)"
    }
    
}

//MARK: ProjectState
enum ProjectState {
    
    case ACTIVE, FINISHED
}
