//
//  StatsTableDataSource.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 22/03/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class StatsTableDataSource: NSObject, UITableViewDataSource {
    
    let cellId = "statsCellId"
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
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
}
