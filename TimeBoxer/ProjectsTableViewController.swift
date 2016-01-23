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
    private let transitionManager = TransitionManager(animator: MyAnimator(), dismissAnimator:MyDismissAnimator())
    private let toEditProjectTransitionManager =
    TransitionManager(animator: ProjectsTableToEditProjectAnimator(),
        dismissAnimator: EditProjectToProjectsTableDismissAnimator(),
        interactiveAnimator: UIPercentDrivenInteractiveTransition(),
        interactiveDismissAnimator: nil)

//----------------------------------------------------------------------------------------------------------------------
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
    
//----------------------------------------------------------------------------------------------------------------------

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //performSegueWithIdentifier("ProjectsTableToEditProject", sender: self)
    }
//----------------------------------------------------------------------------------------------------------------------
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
//MARK: Status Bar
//----------------------------------------------------------------------------------------------------------------------
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
}

//----------------------------------------------------------------------------------------------------------------------
//MARK: ProjectsTableToAddProject animator
private class MyAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private var fromVC: ProjectsTableViewController?
    private var toVC: AddProjectViewController?
    private var container: UIView?
    private var transitionContext:UIViewControllerContextTransitioning?
    private var duration:NSTimeInterval
    
    
    override init() {
        self.duration = 0.3
        super.init()
        registerForKeyboardNotifications()
    }
    
//--------------------------------------------------------------------------------------------------------
    @objc func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval
    {
        return duration
    }

//---------------------------------------------------------------------------------------------------------
   @objc func animateTransition(transitionContext: UIViewControllerContextTransitioning)
    {
        initFields(transitionContext)
        toVC!.view.transform = CGAffineTransformMakeTranslation(0, fromVC!.view.frame.height)
        container!.addSubview(toVC!.view)
        toVC!.projectNameTextField.becomeFirstResponder()
    }
    

//--------------------------------------------------------------------------------------------------------
    func registerForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:",
            name: UIKeyboardWillShowNotification, object: nil)
    }
    
//--------------------------------------------------------------------------------------------------------
    @objc func keyboardWillShow(notification: NSNotification) {
        let keyboardNotification = KeyboardNotification(notification)
        self.duration  =  keyboardNotification.animationDuration
        let options = UIViewAnimationOptions (rawValue: UInt(keyboardNotification.animationCurve << 16))
        
        UIView.animateWithDuration(duration, delay:0.0, options: options, animations: {
            self.toVC!.view.transform = CGAffineTransformIdentity
            }, completion: {
                (finished: Bool) -> Void in
                self.fromVC!.view.removeFromSuperview()
                self.transitionContext!.completeTransition(true)
        })
    }
    
//--------------------------------------------------------------------------------------------------------
    private func initFields(transitionContext: UIViewControllerContextTransitioning) {
        fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
            as? ProjectsTableViewController
        toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
            as? AddProjectViewController
        container = transitionContext.containerView()
        self.transitionContext = transitionContext
    } 
}

//-------------------------------------------------------------------------------------------------------------
//MARK: AddProjectToProjectsTable dismiss animator
private class MyDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private var fromVC: AddProjectViewController?
    private var toVC: ProjectsTableViewController?
    private var container: UIView?
    private var transitionContext:UIViewControllerContextTransitioning?
    private var duration:NSTimeInterval
    
    
    override init() {
        self.duration = 0.3
        super.init()
        registerForKeyboardNotifications()
    }
    
//--------------------------------------------------------------------------------------------------------
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
            self.fromVC!.view.transform = CGAffineTransformMakeTranslation(0, self.fromVC!.view.frame.height)
        },
        completion: {
            (finished:Bool)->Void in
            self.fromVC!.view.removeFromSuperview()
            self.transitionContext!.completeTransition(true)
        })
    }
//------------------------------------------------------------------------------------------------------------------
    private func initFields(context: UIViewControllerContextTransitioning) {
        fromVC = context.viewControllerForKey(UITransitionContextFromViewControllerKey)
            as? AddProjectViewController
        toVC = context.viewControllerForKey(UITransitionContextToViewControllerKey)
            as? ProjectsTableViewController
        container = context.containerView()
        transitionContext = context
    }
    
//------------------------------------------------------------------------------------------------------------------
    @objc func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    @objc func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        initFields(transitionContext)
        container!.insertSubview(toVC!.view, belowSubview: fromVC!.view)
        fromVC!.projectNameTextField.resignFirstResponder()
    }
}

//-------------------------------------------------------------------------------------------------------------------
//MARK: ProjectsTableToEditProjectAnimator
private class ProjectsTableToEditProjectAnimator: AbstractAnimator {
    override init() {
        super.init()
        self.duration = 0.3
    }
    override func doAnimate() {
        let projectsTableView = fromVC!.view
        let editProjectView = toVC!.view
        
        editProjectView.transform = CGAffineTransformMakeTranslation(-projectsTableView.frame.width, 0)
        container!.addSubview(editProjectView)
        UIView.animateWithDuration(transitionDuration(context!),
            animations: {
                editProjectView.transform = CGAffineTransformIdentity
                projectsTableView.transform = CGAffineTransformMakeTranslation(projectsTableView.frame.width, 0)
        },
            completion: {
                (finished:Bool)->Void in
                if self.context!.transitionWasCancelled() {
                    self.context!.completeTransition(false)
                } else {
                    projectsTableView.removeFromSuperview()
                    self.context!.completeTransition(true)
                }
        })
    }
}

//----------------------------------------------------------------------------------------------------------------------
//MARK: EditProjectToProjectsTableDismissAnimator
private class EditProjectToProjectsTableDismissAnimator: AbstractAnimator {
    override init() {
        super.init()
        self.duration = 0.3
    }
    override func doAnimate() {
        let editProjectView = fromVC!.view
        let projectsTableView = toVC!.view
        projectsTableView.transform = CGAffineTransformMakeTranslation(editProjectView.frame.width,0)
        container!.addSubview(projectsTableView)
        UIView.animateWithDuration(transitionDuration(context!),
            animations: {
                projectsTableView.transform = CGAffineTransformIdentity
                editProjectView.transform = CGAffineTransformMakeTranslation(-editProjectView.frame.width, 0)
        },
            completion: {
                (finished:Bool) -> Void in
                editProjectView.removeFromSuperview()
                self.context!.completeTransition(true)
        })
    }
}