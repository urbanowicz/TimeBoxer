//
//  ImprovedContainerViewController.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 13/08/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class ImprovedContainerViewController: UIViewController, UIGestureRecognizerDelegate, POPAnimationDelegate {

    private var projectStatsVC: ProjectStatsViewController!
    private var projectsTableVC: ProjectsTableViewController!
    private var timeSliderVC: TimeSliderViewController!
    private var scrollView: UIScrollView!
    
    private var selectedCell:MyTableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        instantiateChildViewControllers()
        
        let screenSize = UIScreen.mainScreen().bounds.size
        setupChildController(projectStatsVC, withSize: screenSize, origin: CGPointMake(0, 0))
        setupChildController(projectsTableVC, withSize: screenSize, origin:CGPointMake(screenSize.width,0))
        setupChildController(timeSliderVC, withSize: screenSize, origin: CGPointMake(2*screenSize.width,0))
    }
    
    private func setupScrollView() {
        let screenSize = UIScreen.mainScreen().bounds.size
        scrollView = UIScrollView()
        scrollView.frame = CGRect(origin: CGPointZero, size: screenSize)
        scrollView.contentSize = CGSizeMake(screenSize.width*3, screenSize.height)
        scrollView.contentOffset = CGPointMake(screenSize.width,0)
        scrollView.directionalLockEnabled = true
        scrollView.pagingEnabled = true
        scrollView.bounces = false
        scrollView.canCancelContentTouches = false
        scrollView.scrollEnabled = true
        view.addSubview(scrollView)
    }
    
    private func instantiateChildViewControllers() {
        projectStatsVC =
            storyboard!.instantiateViewControllerWithIdentifier("projectStatsViewController") as!
        ProjectStatsViewController
        
        projectsTableVC =
            storyboard!.instantiateViewControllerWithIdentifier("projectsTableViewController") as!
        ProjectsTableViewController
        
        timeSliderVC = storyboard!.instantiateViewControllerWithIdentifier("timeSliderViewController") as?
        TimeSliderViewController
    }
    
    private func setupChildController(child: UIViewController, withSize size:CGSize, origin:CGPoint) {
        addChildViewController(child)
        child.view.frame = CGRect(origin: origin, size: size)
        scrollView.addSubview(child.view)
        child.didMoveToParentViewController(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    //MARK: Private functions

}


