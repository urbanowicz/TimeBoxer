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
    private let workTimeFormatter = WorkTimeFormatter()
    let cellId = "statsCellId"
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return project!.numberOfWeeksSinceStart()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId) as! StatsTableViewCell
        let weekNumber = project!.numberOfWeeksSinceStart() - indexPath.item
        let monday = weekNumberToMonday(weekNumber)
        setupCell(cell, monday: monday, weekNumber: weekNumber)
        return cell
    }
    
    private func setupCell(cell: StatsTableViewCell, monday:NSDate, weekNumber: Int) {
        cell.contentView.backgroundColor = Colors.almostBlack()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd MMM"
        let calendar = NSCalendar.currentCalendar()
        
        setupWeekLabel(cell, weekNumber: weekNumber)
        
        //Monday
        let mondayWorkChunks = project!.workChunksWithDate(monday)
        var totalWork = totalWorkInSecondsForWorkChunks(mondayWorkChunks)
        setupHorizontalBar(cell.mondayBar, totalWorkInSeconds: totalWork)
        let mondayContainerView = cell.mondayBar.superview!
        mondayContainerView.backgroundColor = Colors.almostBlack()
        cell.mondayLabel.textColor = Colors.silver()
        cell.mondayDateLabel.textColor = Colors.silver()
        cell.mondayDateLabel.text = formatter.stringFromDate(monday)

        
        //Tuesday
        let tuesday = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: 1, toDate: monday, options: [])!
        let tuesdayWorkChunks = project!.workChunksWithDate(tuesday)
        totalWork = totalWorkInSecondsForWorkChunks(tuesdayWorkChunks)
        setupHorizontalBar(cell.tuesdayBar, totalWorkInSeconds: totalWork)
        let tuesdayContainerView = cell.tuesdayBar.superview!
        tuesdayContainerView.backgroundColor = Colors.almostBlack()
        cell.tuesdayLabel.textColor = Colors.silver()
        cell.tuesdayDateLabel.textColor = Colors.silver()
        cell.tuesdayDateLabel.text = formatter.stringFromDate(tuesday)
        
        //Wednesday
        let wednesday = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: 1, toDate: tuesday, options: [])!
        let wednesdayWorkChunks = project!.workChunksWithDate(wednesday)
        totalWork = totalWorkInSecondsForWorkChunks(wednesdayWorkChunks)
        setupHorizontalBar(cell.wednesdayBar, totalWorkInSeconds: totalWork)
        let wednesdayContainerView = cell.wednesdayBar.superview!
        wednesdayContainerView.backgroundColor = Colors.almostBlack()
        cell.wednesdayLabel.textColor = Colors.silver()
        cell.wednesdayDateLabel.textColor = Colors.silver()
        cell.wednesdayDateLabel.text = formatter.stringFromDate(wednesday)

        
        //Thursday
        let thursday = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: 1, toDate: wednesday, options: [])!
        let thursdayWorkChunks = project!.workChunksWithDate(thursday)
        totalWork = totalWorkInSecondsForWorkChunks(thursdayWorkChunks)
        setupHorizontalBar(cell.thursdayBar, totalWorkInSeconds: totalWork)
        let thursdayContainerView = cell.thursdayBar.superview!
        thursdayContainerView.backgroundColor = Colors.almostBlack()
        cell.thursdayLabel.textColor = Colors.silver()
        cell.thursdayDateLabel.textColor = Colors.silver()
        cell.thursdayDateLabel.text = formatter.stringFromDate(thursday)

        
        //Friday
        let friday = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: 1, toDate: thursday, options: [])!
        let fridayWorkChunks = project!.workChunksWithDate(friday)
        totalWork = totalWorkInSecondsForWorkChunks(fridayWorkChunks)
        setupHorizontalBar(cell.fridayBar, totalWorkInSeconds: totalWork)
        let fridayContainerView = cell.fridayBar.superview!
        fridayContainerView.backgroundColor = Colors.almostBlack()
        cell.fridayLabel.textColor = Colors.silver()
        cell.fridayDateLabel.textColor = Colors.silver()
        cell.fridayDateLabel.text = formatter.stringFromDate(friday)

        
        //Saturday
        let saturday = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: 1, toDate: friday, options: [])!
        let saturdayWorkChunks = project!.workChunksWithDate(saturday)
        totalWork = totalWorkInSecondsForWorkChunks(saturdayWorkChunks)
        setupHorizontalBar(cell.saturdayBar, totalWorkInSeconds: totalWork)
        let saturdayContainerView = cell.saturdayBar.superview!
        saturdayContainerView.backgroundColor = Colors.almostBlack()
        cell.saturdayLabel.textColor = Colors.silver()
        cell.saturdayDateLabel.textColor = Colors.silver()
        cell.saturdayDateLabel.text = formatter.stringFromDate(saturday)

        
        //Sunday
        let sunday = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: 1, toDate: saturday, options: [])!
        let sundayWorkChunks = project!.workChunksWithDate(sunday)
        totalWork = totalWorkInSecondsForWorkChunks(sundayWorkChunks)
        setupHorizontalBar(cell.sundayBar, totalWorkInSeconds: totalWork)
        let sundayContainerView = cell.sundayBar.superview!
        sundayContainerView.backgroundColor = Colors.almostBlack()
        cell.sundayLabel.textColor = Colors.silver()
        cell.sundayDateLabel.textColor = Colors.silver()
        cell.sundayDateLabel.text = formatter.stringFromDate(sunday)
    }
    
    private func weekNumberToMonday(weekNumber: Int) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let mondayOfTheFirstWeek = calendar.mondayBeforeTheDate(project!.startDate)
        let numberOfWeeksToAdd = weekNumber - 1
        let monday = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: numberOfWeeksToAdd * 7 , toDate: mondayOfTheFirstWeek, options: [])
        return monday!
    }
    
    private func totalWorkInSecondsForWorkChunks(workChunks:[WorkChunk]) -> Int {
        var totalWorkInSeconds = 0
        for workChunk in workChunks {
            totalWorkInSeconds += workChunk.duration
        }
        return totalWorkInSeconds
    }
    
    private func setupWeekLabel(cell:StatsTableViewCell, weekNumber:Int) {
        cell.weekLabel.text = "Week \(weekNumber)"
    }
    private func setupHorizontalBar(bar:HorizontalBarView, totalWorkInSeconds:Int) {
        let eightHoursInSeconds = 8*3600
        bar.value = CGFloat(totalWorkInSeconds) / CGFloat(eightHoursInSeconds)
        bar.backgroundColor = Colors.almostBlack()
        bar.fillColor = Colors.azure()
        bar.labelText = workTimeFormatter.format(totalWorkInSeconds)
    }
}
