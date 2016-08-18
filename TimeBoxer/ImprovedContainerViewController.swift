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
    
    private var transitionState = TransitionState()
    
    private var animationCount = 0
    private var transitionAnimationInProgress = false
    
    private var selectedCell:MyTableViewCell?
    
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
        
        setupPanGestureRecognizerForProjectStatsView()
        setupPanGestureRecognizerForTimeSliderView()
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
        view.addSubview(child.view)
        child.didMoveToParentViewController(self)
    }
    
    private func setupPanGestureRecognizerForProjectStatsView() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ImprovedContainerViewController.handlePanGestureForProjectStatsView(_:)))
        panGestureRecognizer.delegate = self
        projectStatsVC.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    private func setupPanGestureRecognizerForTimeSliderView() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ImprovedContainerViewController.handlePanGestureForTimeSliderView(_:)))
        panGestureRecognizer.delegate = self
        timeSliderVC.view.addGestureRecognizer(panGestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func handlePanGestureForProjectsTableView(panGestureRecognizer: UIPanGestureRecognizer) {
        let cell = panGestureRecognizer.view as! MyTableViewCell
        selectedCell = cell
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
                cell.facadeView.frame.origin.x = transitionState.projectCellOriginX + drawerWidth*signOfDx
                moveProjectStatsViewOriginX(byDelta: dxMinusDrawerWidth)
                moveProjectsTableViewOriginX(byDelta: dxMinusDrawerWidth)
                moveTimeSliderViewOriginX(byDelta: dxMinusDrawerWidth)
            }
        }
        
        if panGestureRecognizer.state == .Ended {
            let dx = panGestureRecognizer.translationInView(view).x
            if fabs(dx) < 50 {
                setFacadeView(forCell: cell)
                return
            }
            
            
            
            let projectsTableViewOriginX = projectsTableVC.view.frame.origin.x
            if projectsTableViewOriginX  > -view.frame.width/2.0 &&
                projectsTableViewOriginX < view.frame.width/2.0 {
                setFacadeView(forCell: cell)
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
        handlePanGestureRecognizerCommon(panGestureRecognizer)
    }
    
    func handlePanGestureForProjectStatsView(panGestureRecognizer: UIPanGestureRecognizer) {
        handlePanGestureRecognizerCommon(panGestureRecognizer)
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        let sourceView = gestureRecognizer.view
        if  sourceView as? MyTableViewCell != nil {
            if transitionAnimationInProgress {
                return false
            } else {
                return true
            }
        }
        
        if transitionAnimationInProgress {
            stopAnimations()
            recordTransitionState()
        }
        
        return true
    }
    
    //MARK:POP Animation delegate
    func pop_animationDidStop(anim: POPAnimation!, finished: Bool) {
        animationCount += 1
        if animationCount == 3 {
            animationCount = 0
            if finished == true {
                transitionAnimationInProgress = false
                resetFacadeViewPosition(forCell: selectedCell!)
                recordTransitionState()
            }
        }
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
        transitionAnimationInProgress = true
        installPositionXAnimation(forView: projectsTableVC.view, positionX: view.frame.width/2.0, delegate: self)
        installPositionXAnimation(forView: projectStatsVC.view, positionX: -view.frame.width/2.0, delegate: self)
        installPositionXAnimation(forView: timeSliderVC.view, positionX: view.frame.width/2.0 + view.frame.width, delegate:self)
    }
    
    private func setProjectStatsView() {
        transitionAnimationInProgress = true
        installPositionXAnimation(forView: projectsTableVC.view, positionX: view.frame.width/2.0 + view.frame.width, delegate: self)
        installPositionXAnimation(forView: projectStatsVC.view, positionX: view.frame.width/2.0, delegate: self)
        installPositionXAnimation(forView: timeSliderVC.view, positionX: view.frame.width/2.0 + 2*view.frame.width, delegate:self)
    }
    
    private func setTimeSliderView() {
        transitionAnimationInProgress = true
        installPositionXAnimation(forView: projectsTableVC.view, positionX: -view.frame.width/2.0, delegate: self)
        installPositionXAnimation(forView: projectStatsVC.view, positionX: -view.frame.width/2.0 - view.frame.width, delegate: self)
        installPositionXAnimation(forView: timeSliderVC.view, positionX: view.frame.width/2.0, delegate:self)
    }
    
    private func setFacadeView(forCell cell:MyTableViewCell) {
        installPositionXAnimation(forView: cell.facadeView, positionX: cell.frame.width/2.0, delegate: nil)
    }
    
    private func resetFacadeViewPosition(forCell cell:MyTableViewCell) {
        cell.facadeView.frame.origin.x = cell.frame.origin.x
    }
    
    private func installPositionXAnimation(forView uiView: UIView, positionX: CGFloat, delegate: POPAnimationDelegate?) {
        let positionXAnimation = POPBasicAnimation(propertyNamed: kPOPLayerPositionX)
        positionXAnimation.toValue = positionX
        positionXAnimation.duration = 0.2
        positionXAnimation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        positionXAnimation.delegate = delegate
        uiView.layer.pop_addAnimation(positionXAnimation, forKey: "positionX")
    }
    
    private func handlePanGestureRecognizerCommon(panGestureRecognizer: UIPanGestureRecognizer) {
        if panGestureRecognizer.state == .Changed {
            let dx = panGestureRecognizer.translationInView(view).x
            moveProjectStatsViewOriginX(byDelta: dx)
            moveProjectsTableViewOriginX(byDelta: dx)
            moveTimeSliderViewOriginX(byDelta: dx)
        }
        
        if panGestureRecognizer.state == .Ended {
            
            let panVelocityX = panGestureRecognizer.velocityInView(view).x
            let direction = panVelocityX/fabs(panVelocityX)
            let stoppingDistance = pow(panVelocityX, 2)/(2*PhysicsConstants.frictionCoef*PhysicsConstants.g)
            let boundedStoppingDistance = min(stoppingDistance, view.frame.width/2.0)
            let projectsTableViewOriginX = projectsTableVC.view.frame.origin.x + (boundedStoppingDistance * direction)
            
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
    
    private func recordTransitionState() {
        transitionState.projectsTableOriginX = projectsTableVC.view.frame.origin.x
        transitionState.projectStatsOriginX = projectStatsVC.view.frame.origin.x
        transitionState.timeSliderOriginX = timeSliderVC.view.frame.origin.x
    }
    
    private func stopAnimations() {
        projectsTableVC.view.layer.pop_removeAnimationForKey("positionX")
        projectStatsVC.view.layer.pop_removeAnimationForKey("positionX")
        timeSliderVC.view.layer.pop_removeAnimationForKey("positionX")
        selectedCell!.facadeView.layer.pop_removeAnimationForKey("positionX")
    }
    
    private func moveProjectStatsViewOriginX(byDelta dx:CGFloat) {
        if dx > 0 {
            projectStatsVC.view.frame.origin.x = min(0, transitionState.projectStatsOriginX + dx)
        } else {
            projectStatsVC.view.frame.origin.x = max(-2*view.frame.width, transitionState.projectStatsOriginX + dx)
        }
    }
    
    private func moveProjectsTableViewOriginX(byDelta dx:CGFloat) {
        if dx > 0 {
            projectsTableVC.view.frame.origin.x = min(view.frame.width, transitionState.projectsTableOriginX + dx)
        } else {
            projectsTableVC.view.frame.origin.x = max(-view.frame.width, transitionState.projectsTableOriginX + dx)
        }
    }
    
    private func moveTimeSliderViewOriginX(byDelta dx:CGFloat) {
        if dx > 0 {
            timeSliderVC.view.frame.origin.x = min(2*view.frame.width, transitionState.timeSliderOriginX + dx)
        } else {
            timeSliderVC.view.frame.origin.x = max(0, transitionState.timeSliderOriginX + dx)
        }
    }
}

struct TransitionState {
    var projectStatsOriginX:CGFloat = 0
    var projectsTableOriginX:CGFloat = 0
    var timeSliderOriginX:CGFloat = 0
    var projectCellOriginX:CGFloat = 0
}

struct PhysicsConstants {
    static let g = CGFloat(9.8)
    static let frictionCoef = CGFloat(10)
}
