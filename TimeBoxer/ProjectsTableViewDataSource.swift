//
//  ProjectsTableViewDataSource.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 09/03/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class ProjectsTableViewDataSource: NSObject, UITableViewDataSource {
    var projects = Array<Project>()
    var projectsTableViewController:ProjectsTableViewController?
    var toEditProjectTransitionManager:TransitionManager?

    private var lastWorkedOnDateFormatter = LastWorkedOnDateFormatter()
    
    let projectsTableId = "projects"
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(projects.count)
        return projects.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:MyTableViewCell? = tableView.dequeueReusableCellWithIdentifier(projectsTableId) as? MyTableViewCell
        if cell == nil {
            cell = MyTableViewCell(style:UITableViewCellStyle.Value1, reuseIdentifier:projectsTableId)
        }
        
        //1. Pass the transition manager to the cell
        cell!.transitionManager = toEditProjectTransitionManager!
        cell!.parentVC = projectsTableViewController!
        cell!.project = projects[indexPath.row]
        cell!.selectionStyle = .None
        
        //2. configure the main text of the cell
        cell!.textLabel!.text = projects[indexPath.row].name
        cell!.textLabel!.font = UIFont(name:"Avenir", size:18)
        cell!.textLabel!.textColor = Colors.almostBlack()
        
        //3. configure the detail text
        cell!.detailTextLabel?.text = lastWorkedOnDateFormatter.formatLastWorkedOnString(projects[indexPath.row].lastWrokedOn())
        cell!.detailTextLabel?.font = UIFont(name:"Avenir", size: 12)
        cell!.detailTextLabel?.textColor = Colors.lightGray()
        return cell!
    }
}
