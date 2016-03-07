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
    @IBOutlet weak var addProjectButton: AddButton!
    
    @IBOutlet weak var noProjectsLabel: UILabel!
    private var projects = Array<Project>()
    let projectsTableId = "projects"
    let projectsDAO = ProjectsDAO()
    private var lastWorkedOnDateFormatter = LastWorkedOnDateFormatter()
    private var newProjectAdded:Bool = false
    
    private let transitionManager =
    TransitionManager(animator: ProjectsTableToAddProjectAnimator(),
        dismissAnimator:AddProjectToProjectsTableDismissAnimator())
    
    private let toEditProjectTransitionManager =
    TransitionManager(animator: ProjectsTableToEditProjectAnimator(),
        dismissAnimator: EditProjectToProjectsTableDismissAnimator(),
        interactiveAnimator: UIPercentDrivenInteractiveTransition(),
        interactiveDismissAnimator: UIPercentDrivenInteractiveTransition())


    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSavedProjects()
        
        //Add self as applicationWillResignActive observer
        let app = UIApplication.sharedApplication()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillResignActive:",
            name: UIApplicationWillResignActiveNotification, object: app)
        
        //Setup UI elements
        setupHeader()
        setupAddProjectButton()
        setupProjectsTable()
        setupAppTitleLabel()
        setupNoProjectsLabel()
    }
    
    func applicationWillResignActive(notification:NSNotification) {
        //save projects to storage
        projectsDAO.saveProjects(projects)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(animated: Bool) {
        if !newProjectAdded {
            if projects.count == 0 {
                noProjectsLabel.hidden = false
                projectsTableView.hidden = true
            } else {
                noProjectsLabel.hidden = true
                projectsTableView.hidden = false
                projectsTableView.reloadData()
            }
        } else {
            noProjectsLabel.hidden = true
            projectsTableView.hidden = false
        }
    }
    
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
    
    private func loadSavedProjects() {
        let savedProjects = projectsDAO.loadProjects()
        if savedProjects != nil {
            projects = savedProjects!
        }
    }
    
    //MARK: Setup UI Elements
    private func setupHeader() {
        headerView.backgroundColor = Colors.oceanBlue()
        headerView.layer.cornerRadius = 6
        headerView.layer.masksToBounds = true
    }
    
    private func setupProjectsTable() {
        projectsTableView.delegate = self
        projectsTableView.dataSource = self
        projectsTableView.separatorColor = Colors.veryLightGray()
        projectsTableView.rowHeight = 62
        projectsTableView.registerClass(MyTableViewCell.self, forCellReuseIdentifier: projectsTableId)
    }
    
    private func setupAppTitleLabel() {
        timeBoxerLabel.textColor = Colors.offWhite()
    }
    
    private func setupAddProjectButton() {
        addProjectButton.borderColor = Colors.kindOfGray()
        addProjectButton.ovalLayerColor = UIColor.whiteColor()
        addProjectButton.frontLayerColor = Colors.kindOfGray()
        
        addProjectButton.ovalLayerHighlightedColor = Colors.kindOfGray()
        addProjectButton.frontLayerHighlightedColor = UIColor.whiteColor()
        addProjectButton.borderWidth = 2.0
    }
    
    private func setupNoProjectsLabel() {
        noProjectsLabel.textColor = Colors.almostBlack()
    }
    
    func cellAtPoint(point:CGPoint) -> MyTableViewCell? {
        if let index = projectsTableView.indexPathForRowAtPoint(point) {
            return projectsTableView.cellForRowAtIndexPath(index) as? MyTableViewCell
        } else  {
            return nil
        }
    }

//MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:MyTableViewCell? = tableView.dequeueReusableCellWithIdentifier(projectsTableId) as? MyTableViewCell
        if cell == nil {
            cell = MyTableViewCell(style:UITableViewCellStyle.Value1, reuseIdentifier:projectsTableId)
        }
        
        //1. Pass the transition manager to the cell
        cell!.transitionManager = toEditProjectTransitionManager
        cell!.parentVC = self
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
    


    
//MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == "ProjectsTableToAddProject" {
            segue.destinationViewController.transitioningDelegate = transitionManager
        }
        if segue.identifier! == "ProjectsTableToEditProject" {
            segue.destinationViewController.transitioningDelegate = toEditProjectTransitionManager
            let selectedCell:MyTableViewCell = sender as! MyTableViewCell
            let editProjectVC:EditProjectViewController = segue.destinationViewController as! EditProjectViewController
            editProjectVC.project = selectedCell.project
        }
    }
    
    @IBAction func unwindToProjectsTableVC(unwindSegue: UIStoryboardSegue) {
        let addProjectVC:AddProjectViewController = unwindSegue.sourceViewController as! AddProjectViewController
        let newProjectName = addProjectVC.projectNameTextField!.text!
        let newProject = Project(projectName: newProjectName, startDate: NSDate())
        projects.insert(newProject, atIndex: 0)
        newProjectAdded = true
    }
    
    
    @IBAction func cancelAddProjectUnwind(unwindSegue: UIStoryboardSegue) {
        
    }
    
    @IBAction func editProjectUnwind(unwindSegue: UIStoryboardSegue) {
       
    }

//MARK: Status Bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
}

