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
    
    private var originalFrames = [CGRect]()
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
            
            let cell = self.cellAtPoint(gestureRecognizer.locationInView(self.projectsTableView))
            self.selectedCell = cell
            
            //self.projectsTableView.backgroundColor = UIColor.yellowColor()
            //cell?.facadeView.backgroundColor = UIColor.redColor()
            func copyFrame(frame: CGRect) -> CGRect {
                return CGRectMake(frame.origin.x, frame.origin.y, frame.width, frame.height)
            }
            
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut,
                animations: {
                    
                    //1. Move the header up 
                    self.originalFrames.append(copyFrame(self.timeBoxerLabel.frame))
                    self.timeBoxerLabel.frame.origin.y = -1.0 * self.timeBoxerLabel.frame.height
                    
                    self.originalFrames.append(copyFrame(self.titleBarSeparator.frame))
                    self.titleBarSeparator.frame.origin.y = -1.0 * self.titleBarSeparator.frame.height
                    
                    
                    //2. Move the add project button down
                    self.originalFrames.append(copyFrame(self.addProjectButton.frame))
                    self.addProjectButton.frame.origin.y = self.view.frame.height
                    
                    //3. Make the project table fill the whole container view
                    self.originalFrames.append(copyFrame(self.projectsTableView.frame))
                    self.projectsTableView.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
                    
                    
                    //4. Move the visible cell out of the way
                    for visibleCell in self.projectsTableView.visibleCells {
                        if visibleCell.frame.origin.y < cell?.frame.origin.y {
                            self.originalFrames.append(visibleCell.frame)
                            visibleCell.frame.origin.y =  -1.0 * visibleCell.frame.height
                            
                        }
                        
                        if visibleCell.frame.origin.y > cell?.frame.origin.y {
                            visibleCell.frame.origin.y = self.view.frame.height
                            self.originalFrames.append(visibleCell.frame)
                        }
                    }

                    //5. Expand the cell itself
                    self.originalFrames.append(copyFrame(cell!.frame))
                    cell?.frame = CGRect(x: 0, y: 0, width: self.projectsTableView.frame.width, height: self.projectsTableView.frame.height)
                    
                    cell?.facadeView.backgroundColor = Colors.purple()

                    
                },
                completion: {
                    finished in
            })
        }
        
        if gestureRecognizer.state == .Ended {
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut,
                   animations: {
                    
                    //1. Restore the header
                    self.timeBoxerLabel.frame = self.originalFrames[0]
                    self.titleBarSeparator.frame = self.originalFrames[1]
                    
                    
                    //2. Restore the project button
                    self.addProjectButton.frame = self.originalFrames[2]
                    
                    //3. Make the project table fill the whole container view
                    self.projectsTableView.frame = self.originalFrames[3]
                    
                    //4. Move the visible cell out of the way
//                    for visibleCell in self.projectsTableView.visibleCells {
//                        if visibleCell.frame.origin.y < cell?.frame.origin.y {
//                            self.originalFrames.append(visibleCell.frame)
//                            visibleCell.frame.origin.y =  -1.0 * visibleCell.frame.height
//                            
//                        }
//                        
//                        if visibleCell.frame.origin.y > cell?.frame.origin.y {
//                            visibleCell.frame.origin.y = self.view.frame.height
//                            self.originalFrames.append(visibleCell.frame)
//                        }
//                    }
                    
                    //5. Expand the cell itself
                    self.selectedCell!.frame = self.originalFrames[4]
                    self.selectedCell!.facadeView.backgroundColor = Colors.almostBlack()
                    
                    
                },
                   completion: {
                    finished in
            })
            
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


