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
    private var projects = ["Coursera, Graphic Design", "project2"]
    let projectsTableId = "projects"
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
        projectsTableView.delegate = self
        projectsTableView.dataSource = self
        projectsTableView.separatorColor = Colors.toUIColor(ColorName.VERY_LIGHT_GRAY)
        projectsTableView.rowHeight = 55
        projectsTableView.registerClass(MyTableViewCell.self, forCellReuseIdentifier: projectsTableId)
        
        timeBoxerLabel.textColor = Colors.toUIColor(ColorName.OFF_WHITE)
        headerView.backgroundColor = Colors.toUIColor(ColorName.ALMOST_BLACK)
        
        addProjectButton.frontLayerColor = Colors.toUIColor(ColorName.WHITE)!
        addProjectButton.ovalLayerColor = Colors.toUIColor(ColorName.ALMOST_BLACK)!
        addProjectButton.ovalLayerHighlightedColor = addProjectButton.ovalLayerColor
        addProjectButton.frontLayerHighlightedColor = addProjectButton.frontLayerColor

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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


//MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->UITableViewCell {
        
        var cell:MyTableViewCell? = tableView.dequeueReusableCellWithIdentifier(projectsTableId) as? MyTableViewCell
        if cell == nil {
            cell = MyTableViewCell(style:UITableViewCellStyle.Value1, reuseIdentifier:projectsTableId)
        }
        
        //1. Pass the transition manager to the cell
        cell!.transitionManager = toEditProjectTransitionManager
        cell!.parentVC = self
        cell!.selectionStyle = .None
        
        //2. configure the main text of the cell
        cell!.textLabel!.text = projects[indexPath.row]
        cell!.textLabel!.font = UIFont(name:"Baskerville", size:20)
        cell!.textLabel!.textColor = Colors.toUIColor(ColorName.ALMOST_BLACK)
        
        //3. configure the detail text
        cell!.detailTextLabel?.text = "2 days ago"
        cell!.detailTextLabel?.font = UIFont(name:"Baskerville", size: 16)
        cell!.detailTextLabel?.textColor = Colors.toUIColor(ColorName.LIGHT_GRAY)
        return cell!
    }
    


    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //performSegueWithIdentifier("ProjectsTableToEditProject", sender: self)
    }

    
//MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == "ProjectsTableToAddProject" {
            segue.destinationViewController.transitioningDelegate = transitionManager
        }
        if segue.identifier! == "ProjectsTableToEditProject" {
            segue.destinationViewController.transitioningDelegate = toEditProjectTransitionManager
        }
    }
    
    @IBAction func unwindToProjectsTableVC(unwindSegue: UIStoryboardSegue) {
        let addProjectVC:AddProjectViewController = unwindSegue.sourceViewController as! AddProjectViewController
        projects.insert(addProjectVC.projectNameTextField.text!, atIndex: 0)
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

//MARK: Persistence
    func dataFilePath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,
            NSSearchPathDomainMask.UserDomainMask,true)
        let documentsDirectory = paths[0] as NSString
        return documentsDirectory.stringByAppendingPathComponent("data.plist") as String
    }
    
}


//MARK: ProjectsTableToAddProject animator
private class ProjectsTableToAddProjectAnimator: AbstractAnimator {
    
    override init() {
        super.init()
        self.duration = 0.3
        registerForKeyboardNotifications()
    }
    
    override func doAnimate() {
        let addProjectVC = toVC! as! AddProjectViewController
        toView!.transform = CGAffineTransformMakeTranslation(0, container!.frame.size.height)
        container!.addSubview(toView!)
        addProjectVC.projectNameTextField.becomeFirstResponder()
    }

    func registerForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:",
            name: UIKeyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let keyboardNotification = KeyboardNotification(notification)
        self.duration  =  keyboardNotification.animationDuration
        let options = UIViewAnimationOptions(rawValue: UInt(keyboardNotification.animationCurve << 16))
        
        UIView.animateWithDuration(duration, delay:0.0, options: options, animations: {
            self.toView!.transform = CGAffineTransformIdentity
            }, completion: {
                (finished: Bool) -> Void in
                //self.fromVC!.view.removeFromSuperview()
                self.context!.completeTransition(true)
        })
    }
}


//MARK: AddProjectToProjectsTable dismiss animator
private class AddProjectToProjectsTableDismissAnimator: AbstractAnimator {
    
    
    override init() {
        super.init()
        self.duration = 0.3
        registerForKeyboardNotifications()
    }
    
    override func doAnimate() {
        let addProjectVC = fromVC! as! AddProjectViewController
        container!.insertSubview(toView!, belowSubview: fromView!)
        addProjectVC.projectNameTextField.resignFirstResponder()
    }

    func registerForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:",
            name: UIKeyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let keyboardNotification = KeyboardNotification(notification)
        self.duration = keyboardNotification.animationDuration
        let options = UIViewAnimationOptions(rawValue: UInt(keyboardNotification.animationCurve << 16))
        UIView.animateWithDuration(duration, delay: 0.0, options: options,
        animations: {
            self.fromView!.transform = CGAffineTransformMakeTranslation(0, self.container!.frame.size.height)
        },
        completion: {
            (finished:Bool)->Void in
            self.fromView!.removeFromSuperview()
            self.context!.completeTransition(true)
        })
    }
}


//MARK: ProjectsTableToEditProjectAnimator
private class ProjectsTableToEditProjectAnimator: AbstractAnimator {
    override init() {
        super.init()
        self.duration = 0.3
    }
    override func doAnimate() {
        let projectsTableView = fromView!
        let editProjectView = toView!
        
        editProjectView.transform = CGAffineTransformMakeTranslation(-container!.frame.size.width, 0)
        container!.addSubview(projectsTableView)
        container!.addSubview(editProjectView)
        UIView.animateWithDuration(transitionDuration(context!),
            animations: {
                editProjectView.transform = CGAffineTransformIdentity
                projectsTableView.transform = CGAffineTransformMakeTranslation(self.container!.frame.size.width, 0)
        },
            completion: {
                (finished:Bool)->Void in
                if self.context!.transitionWasCancelled() {
                    editProjectView.removeFromSuperview()
                    self.context!.completeTransition(false)
                    UIApplication.sharedApplication().keyWindow!.addSubview(projectsTableView)
                } else {
                    //projectsTableView.removeFromSuperview()
                    self.context!.completeTransition(true)
                }
        })
    }
}

//MARK: EditProjectToProjectsTableDismissAnimator
private class EditProjectToProjectsTableDismissAnimator: AbstractAnimator {
    override init() {
        super.init()
        self.duration = 0.3
    }
    
    override func doAnimate() {
        print("BEGIN doAnimate")
        let editProjectView = fromView!
        let projectsTableView = toView!
        let containerFrame = container!.frame
        
        projectsTableView.transform = CGAffineTransformMakeTranslation(containerFrame.size.width,0)
        
        container!.addSubview(projectsTableView)
        UIView.animateWithDuration(transitionDuration(context),
            animations: {
                print("BEGIN animations")
                projectsTableView.transform = CGAffineTransformIdentity
                editProjectView.transform = CGAffineTransformMakeTranslation(-self.container!.frame.size.width, 0)
        },
            completion: {
                (finished:Bool) -> Void in
               print("END Segue")
                if self.context!.transitionWasCancelled() {
                    //projectsTableView.removeFromSuperview()
                    self.context!.completeTransition(false)
                } else {
                    editProjectView.removeFromSuperview()
                    self.context!.completeTransition(true)
                    UIApplication.sharedApplication().keyWindow!.addSubview(projectsTableView)
                }
        })
    }
    
    @objc func animationEnded(transitionCompleted: Bool) {
        print("END animation")
    }
}