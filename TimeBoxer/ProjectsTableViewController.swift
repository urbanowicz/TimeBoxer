//
//  ProjectsTableViewController.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 07.01.2016.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class ProjectsTableViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var titleBar: TitleBar!
    @IBOutlet weak var timeBoxerLabel: UILabel!
    @IBOutlet weak var projectsTableView: UITableView!
    @IBOutlet weak var addProjectButton: AddButton!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var noProjectsLabel: UILabel!
    @IBOutlet weak var useAddButtonLabel: UILabel!
    
    let projectsTableDataSource = ProjectsTableViewDataSource()
    private var lastWorkedOnDateFormatter = LastWorkedOnDateFormatter()
    private var newProjectAdded:Bool = false
    
    let transitionManager =
    TransitionManager(animator: ProjectsTableToAddProjectAnimator(),
        dismissAnimator:AddProjectToProjectsTableDismissAnimator())
    
    let toEditProjectTransitionManager =
    TransitionManager(animator: ProjectsTableToEditProjectAnimator(),
        dismissAnimator: EditProjectToProjectsTableDismissAnimator(),
        interactiveAnimator: UIPercentDrivenInteractiveTransition(),
        interactiveDismissAnimator: UIPercentDrivenInteractiveTransition())


    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup UI elements
        setupTitleBar()
        setupAddProjectButton()
        setupProjectsTable()
        setupAppTitleLabel()
        setupNoProjectsLabel()
        setupUseAddButtonLabel()
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(animated: Bool) {
        if !newProjectAdded {
            if projectsTableDataSource.numberOfProjects() == 0 {
                noProjectsLabel.hidden = false
                useAddButtonLabel.hidden = false
                stackView.hidden = false
                projectsTableView.hidden = true
            } else {
                noProjectsLabel.hidden = true
                useAddButtonLabel.hidden = true
                stackView.hidden = true
                projectsTableView.hidden = false
                projectsTableView.reloadData()
            }
        } else {
            noProjectsLabel.hidden = true
            useAddButtonLabel.hidden = true
            stackView.hidden = true 
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
    
    //MARK: Setup UI Elements
    private func setupTitleBar() {
        titleBar.fillColor = Colors.almostBlack()
        titleBar.cornerRadius = 6
    }
    
    private func setupProjectsTable() {
        projectsTableDataSource.projectsTableViewController = self
        projectsTableView.delegate = self
        projectsTableView.dataSource = projectsTableDataSource
        projectsTableView.separatorColor = Colors.veryLightGray()
        projectsTableView.separatorInset = UIEdgeInsetsZero
    }
    
    private func setupAppTitleLabel() {
        timeBoxerLabel.textColor = Colors.silver()
    }
    
    private func setupAddProjectButton() {
        addProjectButton.borderColor = Colors.silver()
        addProjectButton.ovalLayerColor = Colors.almostBlack()
        addProjectButton.frontLayerColor = Colors.silver()
        addProjectButton.ovalLayerHighlightedColor = Colors.silver()
        addProjectButton.frontLayerHighlightedColor = Colors.almostBlack()
        addProjectButton.borderWidth = 2.0
    }
    
    private func setupNoProjectsLabel() {
        noProjectsLabel.textColor = Colors.silver()
        noProjectsLabel.numberOfLines = 2
        noProjectsLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
    }
    
    private func setupUseAddButtonLabel() {
        useAddButtonLabel.textColor = Colors.lightGray()
        useAddButtonLabel.numberOfLines = 2
        useAddButtonLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
    }
    
    func cellAtPoint(point:CGPoint) -> MyTableViewCell? {
        if let index = projectsTableView.indexPathForRowAtPoint(point) {
            return projectsTableView.cellForRowAtIndexPath(index) as? MyTableViewCell
        } else  {
            return nil
        }
    }

//MARK: Adjust font size
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let myCell = cell as! MyTableViewCell
        myCell.adjustFontSizeToFitTheFrame()
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = projectsTableView.cellForRowAtIndexPath(indexPath) as? MyTableViewCell
        print(cell?.projectNameLabel.frame.size)
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
        projectsTableDataSource.projects.insert(newProject, atIndex: 0)
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

