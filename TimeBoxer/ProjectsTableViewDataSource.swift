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

    private var lastWorkedOnDateFormatter = LastWorkedOnDateFormatter()
    
    let projectsDAO = ProjectsDAO()
    let projectsTableId = "projects"
    
    override init() {
        //Add self as applicationWillResignActive observer
        super.init()
        let app = UIApplication.sharedApplication()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillResignActive:",
            name: UIApplicationWillResignActiveNotification, object: app)
        loadSavedProjects()
    }
    
    func applicationWillResignActive(notification:NSNotification) {
        //save projects to storage
        projectsDAO.saveProjects(projects)
    }
    
    func loadSavedProjects() {
        let savedProjects = projectsDAO.loadProjects()
        if savedProjects != nil {
            projects = savedProjects!
        }
    }
    
    func numberOfProjects() -> Int {
        return projects.count 
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:MyTableViewCell? = tableView.dequeueReusableCellWithIdentifier(projectsTableId) as? MyTableViewCell
        if cell == nil {
            cell = MyTableViewCell(style:UITableViewCellStyle.Value1, reuseIdentifier:projectsTableId)
        }
        
        let panGestureDelegate = ProjectsTableCellPanGestureDelegate()
        panGestureDelegate.tableCell = cell!
        panGestureDelegate.projectsTableVC = projectsTableViewController
        cell!.panGestureRecognizerDelegate = panGestureDelegate
        let panGestureRecognizer = UIPanGestureRecognizer(target: panGestureDelegate, action: "handlePan:")
        panGestureRecognizer.delegate = panGestureDelegate
        cell!.addGestureRecognizer(panGestureRecognizer)
        cell!.project = projects[indexPath.row]
        cell!.selectionStyle = .None
        
        //2. configure the detail text
        cell!.detailTextLabel?.text = lastWorkedOnDateFormatter.formatLastWorkedOnString(projects[indexPath.row].lastWrokedOn())
        cell!.detailTextLabel?.font = UIFont(name:"Avenir", size: 12)
        cell!.detailTextLabel?.sizeToFit()
        cell!.detailTextLabel?.textColor = Colors.lightGray()

        //3. configure the main text of the cell
        cell!.textLabel!.text = projects[indexPath.row].name
        cell!.textLabel!.font = UIFont(name:"Avenir", size:18)
        cell!.textLabel!.numberOfLines = 4
        cell!.textLabel!.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cell!.textLabel!.textColor = Colors.almostBlack()
        let detailTextWidth = cell!.detailTextLabel!.frame.width
        howManyLinesOfTextForLabel(cell!.textLabel!, maxWidth: cell!.frame.width - detailTextWidth)
        return cell!
    }
    
    private func howManyLinesOfTextForLabel(label:UILabel, maxWidth:CGFloat) -> Int {
        let labelCopy = UILabel()
        labelCopy.text = label.text
        labelCopy.font = label.font
        labelCopy.numberOfLines = 1
        labelCopy.sizeToFit()
        label.frame = CGRect(origin: label.frame.origin, size: CGSize(width: maxWidth, height: label.frame.height))
        let actualWidth = labelCopy.frame.width
        let numberOfLines = Int(ceil(actualWidth / maxWidth))
        if numberOfLines >= 4 {
            label.font = label.font.fontWithSize(14)
        } else
            if numberOfLines >= 2 {
              label.font = label.font.fontWithSize(16)
            }
        return numberOfLines
    }
}
