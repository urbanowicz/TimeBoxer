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
        return project!.numberOfWeeksSinceStart()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId) as! StatsTableViewCell
        let weekNumber = project!.numberOfWeeksSinceStart() - indexPath.item
        let monday = weekNumberToMonday(weekNumber)
        setupCell(cell, monday: monday)
        return cell
    }
    
    private func setupCell(cell: StatsTableViewCell, monday:NSDate) {
        cell.contentView.backgroundColor = Colors.almostBlack()
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd-MMM"
        let calendar = NSCalendar.currentCalendar()
        
        //Monday
        let mondayWorkChunks = project!.workChunksWithDate(monday)
        let mondayContainerView = cell.mondayBar.superview!
        mondayContainerView.backgroundColor = Colors.almostBlack()
        cell.mondayLabel.textColor = Colors.silver()
        cell.mondayDateLabel.textColor = Colors.silver()
        cell.mondayDateLabel.text = formatter.stringFromDate(monday)
        cell.mondayBar.fillColor = Colors.azure()
        
        //Tuesday
        let tuesday = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: 1, toDate: monday, options: [])!
        let tuesdayContainerView = cell.tuesdayBar.superview!
        tuesdayContainerView.backgroundColor = Colors.almostBlack()
        cell.tuesdayLabel.textColor = Colors.silver()
        cell.tuesdayDateLabel.textColor = Colors.silver()
        cell.tuesdayDateLabel.text = formatter.stringFromDate(tuesday)
        cell.tuesdayBar.fillColor = Colors.azure()
        
        //Wednesday
        let wednesday = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: 1, toDate: tuesday, options: [])!
        let wednesdayContainerView = cell.wednesdayBar.superview!
        wednesdayContainerView.backgroundColor = Colors.almostBlack()
        cell.wednesdayLabel.textColor = Colors.silver()
        cell.wednesdayDateLabel.textColor = Colors.silver()
        cell.wednesdayDateLabel.text = formatter.stringFromDate(wednesday)
        cell.wednesdayBar.fillColor = Colors.azure()
        
        //Thursday
        let thursday = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: 1, toDate: wednesday, options: [])!
        let thursdayContainerView = cell.thursdayBar.superview!
        thursdayContainerView.backgroundColor = Colors.almostBlack()
        cell.thursdayLabel.textColor = Colors.silver()
        cell.thursdayDateLabel.textColor = Colors.silver()
        cell.thursdayDateLabel.text = formatter.stringFromDate(thursday)
        cell.thursdayBar.fillColor = Colors.azure()
        
        //Friday
        let friday = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: 1, toDate: thursday, options: [])!
        let fridayContainerView = cell.fridayBar.superview!
        fridayContainerView.backgroundColor = Colors.almostBlack()
        cell.fridayLabel.textColor = Colors.silver()
        cell.fridayDateLabel.textColor = Colors.silver()
        cell.fridayDateLabel.text = formatter.stringFromDate(friday)
        cell.fridayBar.fillColor = Colors.azure()
        
        //Saturday
        let saturday = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: 1, toDate: friday, options: [])!
        let saturdayContainerView = cell.saturdayBar.superview!
        saturdayContainerView.backgroundColor = Colors.almostBlack()
        cell.saturdayLabel.textColor = Colors.silver()
        cell.saturdayDateLabel.textColor = Colors.silver()
        cell.saturdayDateLabel.text = formatter.stringFromDate(saturday)
        cell.saturdayBar.fillColor = Colors.azure()
        
        //Sunday
        let sunday = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: 1, toDate: saturday, options: [])!
        let sundayContainerView = cell.sundayBar.superview!
        sundayContainerView.backgroundColor = Colors.almostBlack()
        cell.sundayLabel.textColor = Colors.silver()
        cell.sundayDateLabel.textColor = Colors.silver()
        cell.sundayDateLabel.text = formatter.stringFromDate(sunday)
        cell.sundayBar.fillColor = Colors.azure()
    }
    
    private func weekNumberToMonday(weekNumber: Int) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let mondayOfTheFirstWeek = calendar.mondayBeforeTheDate(project!.startDate)
        let numberOfWeeksToAdd = weekNumber - 1
        let monday = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: numberOfWeeksToAdd * 7 , toDate: mondayOfTheFirstWeek, options: [])
        return monday!
    }
}
