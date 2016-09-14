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
    
    func heat(withDate date: NSDate) -> CGFloat {
        return CGFloat(project.totalSeconds(withDate: date)) / CGFloat(project.dailyGoalSeconds)
    }
    
    func totalSeconds(withDate date:NSDate) -> Int {
        return project.totalSeconds(withDate: date)
    }
}
