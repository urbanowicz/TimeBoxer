//
//  ProjectBasedCalendarHeatMapDataSource.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 03/08/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class ProjectBasedCalendarHeatMapDataSource: NSObject, CalendarHeatMapDataSource {
    
    var project: Project!
    
    func startDate() -> NSDate {
        return project.startDate
    }
    
    func startDateTimeZone() -> NSTimeZone {
        return project.startDateTimeZone
    }
    
    func heat(year: Int, month: Int, day: Int) -> CGFloat {
        return CGFloat(project.totalSeconds(year, month: month, day: day)) / CGFloat(project.dailyGoalSeconds)
    }
    
    func totalSeconds(year: Int, month: Int, day: Int) -> Int {
        return project.totalSeconds(year, month: month, day: day)
    }
}
