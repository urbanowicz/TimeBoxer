//
//  ImprovedContainerViewController.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowiczon 13/08/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class ImprovedContainerViewController: UIViewController, UIGestureRecognizerDelegate {

    private var projectStatsVC: ProjectStatsViewController!
    private var projectsTableVC: ProjectsTableViewController!
    private var timeSliderVC: TimeSliderViewController!
    
    private var transitionState = TransitionState()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        instantiateChildViewControllers()
        
        let screenSize = UIScreen.mainScreen().bounds.size
        setupChildController(projectStatsVC, withSize: screenSize, origin: CGPointMake(-screenSize.width, 0))
        transitionState.projectStatsOriginX = projectStatsVC.view.frame.origin.x
        setupChildController(projectsTableVC, withSize: screenSize, origin:CGPointMake(0,0))
        transitionState.projectsTableOriginX = projectsTableVC.view.frame.origin.x
        setupChildController(timeSliderVC, withSize: screenSize, origin: CGPointMake(screenSize.width,0))
        transitionState.timeSliderOriginX = timeSliderVC.view.frame.origin.x
    }
    
    private func instantiateChildViewControllers() {
        projectStatsVC =
            storyboard!.instantiateViewControllerWithIdentifier("projectStatsViewController") as!
        ProjectStatsViewController
        
        projectsTableVC =
            storyboard!.instantiateViewControllerWithIdentifier("projectsTableViewController") as!
        ProjectsTableViewController
        
        timeSliderVC =             storyboard!.instantiateViewControllerWithIdentifier("timeSliderViewController") as?
        TimeSliderViewController
    }
    
    private func setupChildController(child: UIViewController, withSize size:CGSize, origin:CGPoint) {
        addChildViewController(child)
        child.view.frame = CGRect(origin: origin, size: size)
        view.addSubview(child.view)
        child.didMoveToParentViewController(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func handlePanGestureForProjectsTableView(panGestureRecognizer: UIPanGestureRecognizer) {
        if panGestureRecognizer.state == .Changed {
            let dx = panGestureRecognizer.translationInView(view).x
            let cell = panGestureRecognizer.view as! MyTableViewCell
            let facade = cell.facadeView
            facade.frame.origin.x = transitionState.projectCellOriginX + dx
        }
    }
    
    func handlePanGestureForTimeSliderView(panGestureRecognizer: UIPanGestureRecognizer) {
        
    }
    
    func handlePanGestureForProjectStatsView(panGestureRecognizer: UIPanGestureRecognizer) {
        
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        let sourceView = gestureRecognizer.view
        if  sourceView as? MyTableViewCell != nil {
            return true
        }
        
        if sourceView == projectStatsVC.view {
           
        }
        
        if sourceView == timeSliderVC.view {
            
        }
        
        return true
    }
    
    func switchViewControllers(fromVC:UIViewController, toVC:UIViewController, animator:Animator?) {
    
    }
    
    //MARK: Disable auto rotate
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    //MARK: Hide status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

struct TransitionState {
    var projectStatsOriginX:CGFloat = 0
    var projectsTableOriginX:CGFloat = 0
    var timeSliderOriginX:CGFloat = 0
    var projectCellOriginX:CGFloat = 0
}
