//
//  ProjectsTableViewController.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 07.01.2016.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class ProjectsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var timeBoxerLabel: UILabel!
    @IBOutlet weak var projectsTableView: UITableView!
    private var projects = ["Coursera, Graphic Design", "project2"]
    let projectsTableId = "projects"
    private var newProjectAdded:Bool = false

//----------------------------------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        projectsTableView.delegate = self
        projectsTableView.dataSource = self
        timeBoxerLabel.textColor = Colors.toUIColor(ColorName.OFF_WHITE)
        headerView.backgroundColor = Colors.toUIColor(ColorName.ALMOST_BLACK)
        
    }

//----------------------------------------------------------------------------------------------------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
//----------------------------------------------------------------------------------------------------------------------
    override func viewDidAppear(animated: Bool) {
        if newProjectAdded {
            let index = NSIndexPath(forItem:0, inSection: 0)
            projectsTableView.beginUpdates()
            projectsTableView.insertRowsAtIndexPaths([index],
                withRowAnimation: UITableViewRowAnimation.Top)
            projectsTableView.endUpdates()
            newProjectAdded = false
        }
    }

//----------------------------------------------------------------------------------------------------------------------
//MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }

//----------------------------------------------------------------------------------------------------------------------
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->UITableViewCell {
        
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(projectsTableId)
        if cell == nil {
            cell = UITableViewCell(style:UITableViewCellStyle.Value1, reuseIdentifier:projectsTableId)
        }
        
        //1. configure the main text of the cell
        cell!.textLabel!.text = projects[indexPath.row]
        cell!.textLabel!.font = UIFont(name:"Baskerville", size:20)
        cell!.textLabel!.textColor = Colors.toUIColor(ColorName.ALMOST_BLACK)
        
        //3. configure the detail text
        cell!.detailTextLabel?.text = "2 days ago"
        cell!.detailTextLabel?.font = UIFont(name:"Baskerville", size: 16)
        cell!.detailTextLabel?.textColor = Colors.toUIColor(ColorName.LIGHT_GRAY)
        return cell!
    }
    
//----------------------------------------------------------------------------------------------------------------------
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
    }


//----------------------------------------------------------------------------------------------------------------------
//MARK: Navigation
    @IBAction func unwindToProjectsTableVC(unwindSegue: UIStoryboardSegue) {
        let addProjectVC:AddProjectViewController = unwindSegue.sourceViewController as! AddProjectViewController
        projects.insert(addProjectVC.projectNameTextField.text!, atIndex: 0)
        newProjectAdded = true
    }
//MARK: Status Bar
//----------------------------------------------------------------------------------------------------------------------
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
//    override func prefersStatusBarHidden() -> Bool {
//        return true
//    }
    
}
