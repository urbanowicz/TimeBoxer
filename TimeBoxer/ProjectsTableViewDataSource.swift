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
    let projectsTableId = "ProjectCell"
    
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
        let cell = tableView.dequeueReusableCellWithIdentifier(projectsTableId) as! MyTableViewCell
        cell.project = projects[indexPath.row]
        cell.facadeView.backgroundColor = Colors.almostBlack()
        setupPanGestureRecognizerForCell(cell)
        setupLastWorkedOnLabelForCell(cell, indexPath: indexPath)
        setupProjectNameLabelForCell(cell, indexPath: indexPath)
        setupLeftDrawerForCell(cell)
        setupRightDrawerForCell(cell)
        setupCellSeparatorForCell(cell)
        return cell
    }
    
    private func setupPanGestureRecognizerForCell(cell:MyTableViewCell) {
        let panGestureDelegate = ProjectsTableCellPanGestureDelegate()
        panGestureDelegate.tableCell = cell
        panGestureDelegate.projectsTableVC = projectsTableViewController
        cell.panGestureRecognizerDelegate = panGestureDelegate
        let panGestureRecognizer = UIPanGestureRecognizer(target: panGestureDelegate, action: "handlePan:")
        panGestureRecognizer.delegate = panGestureDelegate
        cell.addGestureRecognizer(panGestureRecognizer)
    }
    
    
    private func setupLastWorkedOnLabelForCell(cell:MyTableViewCell, indexPath:NSIndexPath) {
        cell.lastWorkedOnLabel.text =
            lastWorkedOnDateFormatter.formatLastWorkedOnString(projects[indexPath.row].lastWrokedOn())
        cell.lastWorkedOnLabel.textColor = Colors.azure()
    }
    
    private func setupProjectNameLabelForCell(cell:MyTableViewCell, indexPath:NSIndexPath) {
        cell.projectNameLabel.text = projects[indexPath.row].name
        cell.projectNameLabel.textColor = Colors.silver()
    }
    
    private func setupLeftDrawerForCell(cell:MyTableViewCell) {
        cell.leftDrawer.backgroundColor = UIColor.blueColor()
    }
    
    private func setupRightDrawerForCell(cell:MyTableViewCell) {
        cell.rightDrawer.backgroundColor = UIColor.greenColor()
    }
    
    private func setupCellSeparatorForCell(cell:MyTableViewCell) {
        cell.cellSeparator.backgroundColor = Colors.veryLightGray()
    }
}
