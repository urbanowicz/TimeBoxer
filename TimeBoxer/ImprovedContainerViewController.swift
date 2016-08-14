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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        instantiateChildViewControllers()
        
        let screenSize = UIScreen.mainScreen().bounds.size
        setupChildController(projectStatsVC, withSize: screenSize, origin: CGPointMake(-screenSize.width, 0))
        setupChildController(projectsTableVC, withSize: screenSize, origin:CGPointMake(0,0))
        setupChildController(timeSliderVC, withSize: screenSize, origin: CGPointMake(screenSize.width,0))
        
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
        print("Handling swipe on a cell")
    }
    
    func handlePanGestureForTimeSliderView(panGestureRecognizer: UIPanGestureRecognizer) {
        
    }
    
    func handlePanGestureForProjectStatsView(panGestureRecognizer: UIPanGestureRecognizer) {
        
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
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
