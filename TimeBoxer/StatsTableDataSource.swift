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
        cell.mondayLabel.textColor = Colors.silver()
        cell.mondayDateLabel.textColor = Colors.silver()
        cell.mondayBar.superview!.backgroundColor = Colors.almostBlack()
        cell.mondayBar.fillColor = Colors.azure()
    }
}
