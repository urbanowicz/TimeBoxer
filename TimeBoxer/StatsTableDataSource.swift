//
//  StatsTableDataSource.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 22/03/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class StatsTableDataSource: NSObject, UITableViewDataSource {
    var project:Project?

    let cellId = "statsCellId"
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfWeeks()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId) as! StatsTableViewCell
        setupCell(cell)
        return cell
    }
    
    private func setupCell(cell: StatsTableViewCell) {
        cell.contentView.backgroundColor = Colors.almostBlack()
        
        //Monday
        let mondayContainerView = cell.mondayBar.superview!
        mondayContainerView.backgroundColor = Colors.almostBlack()
        cell.mondayLabel.textColor = Colors.silver()
        cell.mondayDateLabel.textColor = Colors.silver()
        cell.mondayBar.fillColor = Colors.azure()
        
        //Tuesday
        let tuesdayContainerView = cell.tuesdayBar.superview!
        tuesdayContainerView.backgroundColor = Colors.almostBlack()
        cell.tuesdayLabel.textColor = Colors.silver()
        cell.tuesdayDateLabel.textColor = Colors.silver()
        cell.tuesdayBar.fillColor = Colors.azure()
        
        //Wednesday
        let wednesdayContainerView = cell.wednesdayBar.superview!
        wednesdayContainerView.backgroundColor = Colors.almostBlack()
        cell.wednesdayLabel.textColor = Colors.silver()
        cell.wednesdayDateLabel.textColor = Colors.silver()
        cell.wednesdayBar.fillColor = Colors.azure()
        
        //Thursday
        let thursdayContainerView = cell.thursdayBar.superview!
        thursdayContainerView.backgroundColor = Colors.almostBlack()
        cell.thursdayLabel.textColor = Colors.silver()
        cell.thursdayDateLabel.textColor = Colors.silver()
        cell.thursdayBar.fillColor = Colors.azure()
        
        //Friday
        let fridayContainerView = cell.fridayBar.superview!
        fridayContainerView.backgroundColor = Colors.almostBlack()
        cell.fridayLabel.textColor = Colors.silver()
        cell.fridayDateLabel.textColor = Colors.silver()
        cell.fridayBar.fillColor = Colors.azure()
        
        //Saturday
        let saturdayContainerView = cell.saturdayBar.superview!
        saturdayContainerView.backgroundColor = Colors.almostBlack()
        cell.saturdayLabel.textColor = Colors.silver()
        cell.saturdayDateLabel.textColor = Colors.silver()
        cell.saturdayBar.fillColor = Colors.azure()
        
        //Sunday
        let sundayContainerView = cell.sundayBar.superview!
        sundayContainerView.backgroundColor = Colors.almostBlack()
        cell.sundayLabel.textColor = Colors.silver()
        cell.sundayDateLabel.textColor = Colors.silver()
        cell.sundayBar.fillColor = Colors.azure()
    }
    
    private func numberOfWeeks() -> Int {
        let mondayInWeekOne = mondayBeforeTheDate(project!.startDate)
        let today = NSDate()
        let daysSinceStart = dayDifferenceBetween(today, earlierDate: mondayInWeekOne) + 1
        

        
        var numberOfWeeks = daysSinceStart / 7
        if daysSinceStart % 7 > 0 {
            numberOfWeeks += 1
        }
        return numberOfWeeks
    }
    
    private func mondayBeforeTheDate(date:NSDate) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([NSCalendarUnit.Weekday], fromDate:date)
        let numberOfDaysSinceMonday = components.weekday - 2
        let monday = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: -numberOfDaysSinceMonday, toDate: date, options: NSCalendarOptions.WrapComponents)!
        return monday
    }
    
    func dayDifferenceBetween(laterDate: NSDate, earlierDate: NSDate) -> Int {
        let calendar = NSCalendar.currentCalendar()
        let laterDateNoTimeComponent = dateWithNoTimeComponentFromDate(laterDate)
        let earlierDateNoTimeComponent = dateWithNoTimeComponentFromDate(earlierDate)
        let dayDifference =
        calendar.components(NSCalendarUnit.Day, fromDate: earlierDateNoTimeComponent, toDate: laterDateNoTimeComponent, options: [])
        return dayDifference.day
    }
    
    private func dateWithNoTimeComponentFromDate(date: NSDate) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        var unit = NSCalendarUnit.Year
        unit.unionInPlace(NSCalendarUnit.Month)
        unit.unionInPlace(NSCalendarUnit.Day)
        let components = calendar.components(unit, fromDate: date)
        components.second = 0
        components.minute = 0
        components.hour = 0
        components.nanosecond = 0
        return calendar.dateFromComponents(components)!
    }
}
