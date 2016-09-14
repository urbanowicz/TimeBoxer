//
//  ProjectsTableViewController.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 07.01.2016.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class ProjectsTableViewController: UIViewController, UITableViewDelegate, AddProjectTrainDelegate {

    @IBOutlet weak var timeBoxerLabel: UILabel!
    @IBOutlet weak var titleBarSeparator: UIView!
    @IBOutlet weak var projectsTableView: UITableView!
    @IBOutlet weak var addProjectButton: AddButton!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var noProjectsLabel: UILabel!
    @IBOutlet weak var useAddButtonLabel: UILabel!
    
    let projectsTableDataSource = ProjectsTableViewDataSource()
    private var lastWorkedOnDateFormatter = LastWorkedOnDateFormatter()
    private var newProjectAdded:Bool = false
    
    private var originalFrames = [(view:UIView, frame:CGRect)]()
    private var originalContentOffset:CGFloat?
    private var selectedCell: MyTableViewCell?
    
    let transitionManager =
    TransitionManager(animator: ProjectsTableToAddProjectAnimator(),
        dismissAnimator:AddProjectToProjectsTableDismissAnimator())


    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup UI elements
        let longPressGestureRecognizer = UILongPressGestureRecognizer()
        view.addGestureRecognizer(longPressGestureRecognizer)
        longPressGestureRecognizer.addTarget(self, action: #selector(handleLongPressGesture(_:)))
        view.backgroundColor = Colors.almostBlack()
        setupAddProjectButton()
        setupProjectsTable()
        setupAppTitleLabel()
        setupTitleBarSeparator()
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
                titleBarSeparator.hidden = true
                timeBoxerLabel.hidden = true
            } else {
                noProjectsLabel.hidden = true
                useAddButtonLabel.hidden = true
                stackView.hidden = true
                projectsTableView.hidden = false
                titleBarSeparator.hidden = false
                timeBoxerLabel.hidden = false
                projectsTableView.reloadData()
            }
        } else {
            noProjectsLabel.hidden = true
            useAddButtonLabel.hidden = true
            stackView.hidden = true 
            projectsTableView.hidden = false
            titleBarSeparator.hidden = false
            timeBoxerLabel.hidden = false 
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
    
    override func willMoveToParentViewController(parent: UIViewController?) {
        if let containerVC = parent as? ImprovedContainerViewController {
            projectsTableDataSource.containerVC = containerVC
        }
    }
    
    //MARK: Setup UI Elements
    
    private func setupProjectsTable() {
        projectsTableDataSource.projectsTableViewController = self
        projectsTableView.delegate = self
        projectsTableView.backgroundColor = Colors.almostBlack()
        projectsTableView.dataSource = projectsTableDataSource
        projectsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    private func setupAppTitleLabel() {
        timeBoxerLabel.textColor = Colors.azure()
    }
    
    private func setupAddProjectButton() {
        addProjectButton.borderWidth = 0.0
        addProjectButton.roundLayerColor = Colors.silver()
        addProjectButton.frontLayerColor = Colors.almostBlack()

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
    
    private func setupTitleBarSeparator() {
        titleBarSeparator.backgroundColor = Colors.veryLightGray().withAlpha(0.1)
    }
    
    func cellAtPoint(point:CGPoint) -> MyTableViewCell? {
        if let index = projectsTableView.indexPathForRowAtPoint(point) {
            return projectsTableView.cellForRowAtIndexPath(index) as? MyTableViewCell
        } else  {
            return nil
        }
    }
    
    func handleLongPressGesture(gestureRecognizer:UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .Began {
            
            selectedCell = self.cellAtPoint(gestureRecognizer.locationInView(self.projectsTableView))
            if selectedCell == nil {
                return
            }
            
            performSegueWithIdentifier("projectsTableToProjectSettings", sender:self)
        }
    }

    
    func didAddNewProject(newProject:Project) {
        projectsTableDataSource.projects.insert(newProject, atIndex: 0)
        newProjectAdded = true
    }
    
//MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == "ProjectsTableToAddProject" {
            let addProjectPageViewController = segue.destinationViewController as! AddProjectPageViewController
            addProjectPageViewController.trainDelegate = self
            addProjectPageViewController.transitioningDelegate = transitionManager
        }
    }
    
    @IBAction func unwindToProjectsTableVC(unwindSegue: UIStoryboardSegue) {

    }
    
    
    @IBAction func cancelAddProjectUnwind(unwindSegue: UIStoryboardSegue) {
        
    }
    
    @IBAction func editProjectUnwind(unwindSegue: UIStoryboardSegue) {
       
    }

//MARK: Disable auto rotate
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
}


