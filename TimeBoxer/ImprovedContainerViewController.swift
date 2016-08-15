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
        let cell = panGestureRecognizer.view as! MyTableViewCell
        if panGestureRecognizer.state == .Began {

        }
        if panGestureRecognizer.state == .Changed {
            let dx = panGestureRecognizer.translationInView(view).x
            let cell = panGestureRecognizer.view as! MyTableViewCell
            let facade = cell.facadeView
            let drawerWidth = cell.drawerWidth
            if (fabs(dx) < 50) {
                facade.frame.origin.x = transitionState.projectCellOriginX + dx
            } else {
                let signOfDx = dx / fabs(dx)
                let dxMinusDrawerWidth = signOfDx * (fabs(dx) - drawerWidth)
                projectStatsVC.view.frame.origin.x = transitionState.projectStatsOriginX + dxMinusDrawerWidth
                projectsTableVC.view.frame.origin.x = transitionState.projectsTableOriginX + dxMinusDrawerWidth
                timeSliderVC.view.frame.origin.x = transitionState.timeSliderOriginX + dxMinusDrawerWidth
            }
        }
        
        if panGestureRecognizer.state == .Ended {
            let dx = panGestureRecognizer.translationInView(view).x
            if fabs(dx) < 50 {
                let facadePositionXAnimation = POPBasicAnimation(propertyNamed: kPOPLayerPositionX)
                facadePositionXAnimation.toValue = cell.frame.width/2.0
                facadePositionXAnimation.duration = 0.2
                facadePositionXAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                cell.facadeView.layer.pop_addAnimation(facadePositionXAnimation, forKey: "positionX")
                return
            }
            
            let projectsTableViewOriginX = projectsTableVC.view.frame.origin.x
            if projectsTableViewOriginX  > -view.frame.width/2.0 &&
                projectsTableViewOriginX < view.frame.width/2.0 {
                setProjectsTableView()
                return
            }
            
            if projectsTableViewOriginX <= -view.frame.width/2.0 {
                setTimeSliderView()
                return
            }
            
            if projectsTableViewOriginX >= view.frame.width/2.0 {
                setProjectStatsView()
                return
            }
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
    
    //MARK: Private functions
    private func setProjectsTableView() {
        installPositionXAnimation(forView: projectsTableVC.view, positionX: view.frame.width/2.0)
        installPositionXAnimation(forView: projectStatsVC.view, positionX: -view.frame.width/2.0)
        installPositionXAnimation(forView: timeSliderVC.view, positionX: view.frame.width/2.0 + view.frame.width)
    }
    
    private func setProjectStatsView() {
        installPositionXAnimation(forView: projectsTableVC.view, positionX: view.frame.width/2.0 + view.frame.width)
        installPositionXAnimation(forView: projectStatsVC.view, positionX: view.frame.width/2.0)
        installPositionXAnimation(forView: timeSliderVC.view, positionX: view.frame.width/2.0 + 2*view.frame.width)
    }
    
    private func setTimeSliderView() {
        installPositionXAnimation(forView: projectsTableVC.view, positionX: -view.frame.width/2.0)
        installPositionXAnimation(forView: projectStatsVC.view, positionX: -view.frame.width/2.0 - view.frame.width)
        installPositionXAnimation(forView: timeSliderVC.view, positionX: view.frame.width/2.0)
    }
    
    private func installPositionXAnimation(forView uiView: UIView, positionX: CGFloat) {
        let positionXAnimation = POPBasicAnimation(propertyNamed: kPOPLayerPositionX)
        positionXAnimation.toValue = positionX
        positionXAnimation.duration = 0.3
        positionXAnimation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        uiView.layer.pop_addAnimation(positionXAnimation, forKey: "positionX")
    }
    
}

struct TransitionState {
    var projectStatsOriginX:CGFloat = 0
    var projectsTableOriginX:CGFloat = 0
    var timeSliderOriginX:CGFloat = 0
    var projectCellOriginX:CGFloat = 0
}
