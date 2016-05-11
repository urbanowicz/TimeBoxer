//
//  ProjectsTableViewController.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 07.01.2016.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class ProjectsTableViewController: UIViewController, UITableViewDelegate {

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
            } else {
                noProjectsLabel.hidden = true
                useAddButtonLabel.hidden = true
                stackView.hidden = true
                projectsTableView.hidden = false
                titleBarSeparator.hidden = false
                projectsTableView.reloadData()
            }
        } else {
            noProjectsLabel.hidden = true
            useAddButtonLabel.hidden = true
            stackView.hidden = true 
            projectsTableView.hidden = false
            titleBarSeparator.hidden = false
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
    
    private func setupProjectsTable() {
        projectsTableDataSource.projectsTableViewController = self
        projectsTableView.delegate = self
        projectsTableView.backgroundColor = Colors.almostBlack()
        projectsTableView.dataSource = projectsTableDataSource
        projectsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
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
    
    private func setupTitleBarSeparator() {
        titleBarSeparator.backgroundColor = Colors.veryLightGray()
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
        
            func backupTupleForView(uiViewInstance: UIView) -> (view: UIView,frame: CGRect) {
                let frameCopy = CGRectMake(uiViewInstance.frame.origin.x,
                                           uiViewInstance.frame.origin.y,
                                           uiViewInstance.frame.width,
                                           uiViewInstance.frame.height)
                return (uiViewInstance, frameCopy)
            }
            
            NSLayoutConstraint.deactivateConstraints([self.selectedCell!.projectNameLabelBottomToFacadeViewTopConstraint])
            UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut,
                animations: {
                    
                    //1. Move the header up
                    self.originalFrames.append(backupTupleForView(self.timeBoxerLabel))
                    self.timeBoxerLabel.frame.origin.y = -1.0 * self.timeBoxerLabel.frame.height
                    
                    self.originalFrames.append(backupTupleForView(self.titleBarSeparator))
                    self.titleBarSeparator.frame.origin.y = -1.0 * self.titleBarSeparator.frame.height
                    
                    
                    //2. Move the add project button down
                    self.originalFrames.append(backupTupleForView(self.addProjectButton))
                    self.addProjectButton.frame.origin.y = self.view.frame.height
                    
                    //3. Make the project table fill the whole container view
                    self.originalFrames.append(backupTupleForView(self.projectsTableView))
                    self.originalContentOffset = self.projectsTableView.contentOffset.y
                    self.projectsTableView.setContentOffset(CGPoint(x:0, y:0), animated: false)
                    self.projectsTableView.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)

                    
                    //4. Move the visible cell out of the way
                    for visibleCell in self.projectsTableView.visibleCells {
                        if visibleCell.frame.origin.y < self.selectedCell!.frame.origin.y {
                            self.originalFrames.append(backupTupleForView(visibleCell))
                            visibleCell.frame.origin.y =  -1.0 * visibleCell.frame.height
                        }
                        
                        if visibleCell.frame.origin.y > self.selectedCell?.frame.origin.y {
                            self.originalFrames.append(backupTupleForView(visibleCell))
                            visibleCell.frame.origin.y = self.view.frame.height
                        }
                    }

                    //5. Expand the cell itself
                    self.originalFrames.append(backupTupleForView(self.selectedCell!))
                    self.selectedCell!.frame = CGRect(x: 0, y: 0, width: self.projectsTableView.frame.width, height: self.projectsTableView.frame.height)
                    self.selectedCell!.facadeView.backgroundColor = Colors.almostBlack()
                    

                    
                },
                completion: {
                    finished in
                    let deleteProjectButton = self.selectedCell!.deleteProjectButton
                    let facadeView = self.selectedCell!.facadeView
                    deleteProjectButton.addTarget(self, action: #selector(ProjectsTableViewController.deleteProjectButtonPressed), forControlEvents: .TouchDown)
                    deleteProjectButton.alpha = 0.0
                    deleteProjectButton.frame = CGRectZero
                    deleteProjectButton.frame.origin.x = facadeView.frame.width / 2.0
                    deleteProjectButton.frame.origin.y = facadeView.frame.height / 2.0
                    self.selectedCell!.setupDeleteProjectButton()
                    facadeView.addSubview(deleteProjectButton)
                    UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                        //6. Display the delete and cancel buttons
                        deleteProjectButton.alpha = 1.0
                        let buttonHeight = CGFloat(50)
                        let buttonWidth = CGFloat(100)
                        let buttonX = facadeView.frame.width / 2.0 - buttonWidth / 2.0
                        let buttonY = facadeView.frame.height / 2.0 - buttonHeight / 2.0
                        deleteProjectButton.frame = CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight)
                        
                        }, completion: {finished in })
            })
        }
    }
    
    func deleteProjectButtonPressed() {
        
        UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.selectedCell!.deleteProjectButton.alpha = 0.0
            let buttonX = self.selectedCell!.facadeView.frame.width / 2.0
            let buttonY = self.selectedCell!.facadeView.frame.height / 2.0
            self.selectedCell!.deleteProjectButton.frame = CGRectMake(buttonX, buttonY, 0, 0)
            },
           completion: {
            finished in
            self.selectedCell!.deleteProjectButton.removeFromSuperview()
            UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut,
                animations: {
                    for (uiView, frame) in self.originalFrames {
                        uiView.frame = frame
                    }
                    self.projectsTableView.setContentOffset(CGPoint(x:0, y: self.originalContentOffset!), animated: false)
                    self.selectedCell!.facadeView.backgroundColor = Colors.almostBlack()
                    NSLayoutConstraint.activateConstraints ([self.selectedCell!.projectNameLabelBottomToFacadeViewTopConstraint])
                    
                },
                completion: {
                    finished in
                    self.originalFrames.removeAll()
            })
        })
    }

//MARK: Adjust font size
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let myCell = cell as! MyTableViewCell
        myCell.adjustFontSizeToFitTheFrame()
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {

    }
    
//MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == "ProjectsTableToAddProject" {
            segue.destinationViewController.transitioningDelegate = transitionManager
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
//MARK: Disable auto rotate
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
}


