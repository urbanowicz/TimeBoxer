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
    var containerVC: ImprovedContainerViewController!
    
    let projectsDAO = ProjectsDAO()
    let projectsTableId = "ProjectCell"
    
    override init() {
        //Add self as applicationWillResignActive observer
        super.init()
        let app = UIApplication.sharedApplication()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UIApplicationDelegate.applicationWillResignActive(_:)),
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
        cell.projectNameLabel.text = projects[indexPath.row].name
        cell.delegate = containerVC
        return cell
    }
    
    func deleteProject(name:String) {
        var indexToDelete = 0
        for project in projects {
            if project.name == name {
                break
            }
            indexToDelete += 1
        }
        if indexToDelete < projects.count {
            projects.removeAtIndex(indexToDelete)
        }
    }
}
