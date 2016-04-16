//
//  ContainerViewController.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 02.01.2016.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController, UIGestureRecognizerDelegate{
    private var timeSliderVC:TimeSliderViewController?
    private var projectsTableVC: ProjectsTableViewController?
    private var projectStatsVC: ProjectStatsViewController?
        
    private var toTimeSliderSwipeHandler:ProjectsTableToTimeSliderSwipeHandler?
    private var toProjectsTableSwipeHandler:TimeSliderToProjectsTableSwipeHandler?
    private var toProjectStatsSwipeHandler:ProjectsTableToProjectStatsSwipeHandler?
    private var projectStatsToProjectsTableSwipeHandler:ProjectStatsToProjectsTableSwipeHandler?
    
    //transition directions
    let toTimeSliderTransition = 0
    let timeSliderToProjectsTableTransition = 1
    let toProjectStatsTransition = 2
    let projectStatsToProjectsTableTransition = 3
    var transitionDirection:Int = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //1. Add a Pan Gesture recognizer
        let panGestureRecognizer = UIPanGestureRecognizer()
        panGestureRecognizer.addTarget(self, action: #selector(ContainerViewController.handlePanGesture(_:)))
        view.addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.delegate = self
        
        //2. Create the Time Slider View
        timeSliderVC =
            storyboard!.instantiateViewControllerWithIdentifier("timeSliderViewController") as?
        TimeSliderViewController
        
        //3. Create the Projects Table View
        projectsTableVC =
            storyboard!.instantiateViewControllerWithIdentifier("projectsTableViewController") as?
            ProjectsTableViewController
        displayViewController(projectsTableVC!)
        
        //4. Create the Project Stats View
        projectStatsVC =
            storyboard!.instantiateViewControllerWithIdentifier("projectStatsViewController") as?
            ProjectStatsViewController 
        
    }

    
    func switchViewControllers(fromVC:UIViewController, toVC:UIViewController, animator:Animator?) {
        self.addChildViewController(toVC)
        fromVC.willMoveToParentViewController(nil)
        toVC.view.frame = self.view.frame
        if animator != nil {
            animator!.animateTransition(fromVC, toVC: toVC, container: self.view, completion:
            {
                fromVC.removeFromParentViewController()
                toVC.didMoveToParentViewController(self)
            })
        } else {
            view.addSubview(toVC.view)
            fromVC.view.removeFromSuperview()
            fromVC.removeFromParentViewController()
            toVC.didMoveToParentViewController(self)
        }
    }
    

    private func displayViewController(vc: UIViewController)
    {
        self.addChildViewController(vc)
        vc.view.frame = self.view.frame
        self.view.addSubview(vc.view)
        vc.didMoveToParentViewController(self)
    }
    


    private func hideViewController(vc: UIViewController)
    {
        vc.willMoveToParentViewController(nil)
        vc.view.removeFromSuperview()
        vc.removeFromParentViewController()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }


//MARK: PanGestureRecognizer
    func handlePanGesture(gestureRecognizer: UIPanGestureRecognizer) {
        
        if gestureRecognizer.state == .Began {
            var toVC: UIViewController
            switch(transitionDirection) {
            case timeSliderToProjectsTableTransition:
                toVC = projectsTableVC!
                toVC.view.frame = view.frame
                toVC.view.frame.origin.x  = view.frame.origin.x - view.frame.width
                view.addSubview(toVC.view)
            case toTimeSliderTransition:
                toVC = timeSliderVC!
                toVC.view.frame = self.view.frame
                toVC.view.frame.origin.x  = view.frame.origin.x + view.frame.width
                view.addSubview(toVC.view)
            case toProjectStatsTransition:
                toVC = projectStatsVC!
                toVC.view.frame = view.frame
                toVC.view.frame.origin.x  = view.frame.origin.x - view.frame.width
                view.addSubview(toVC.view)
            case projectStatsToProjectsTableTransition:
                toVC = projectsTableVC!
                toVC.view.frame = view.frame
                toVC.view.frame.origin.x = view.frame.origin.x + view.frame.width
                view.addSubview(toVC.view)
            default:
                print("Reached a default case in switch. This shouldn't have happen. Search for string: DEFAULT1 in the source code")
            }
            
        }
        
        if gestureRecognizer.state == .Changed {
            switch(transitionDirection) {
            case toTimeSliderTransition:
                toTimeSliderSwipeHandler!.handleSwipeChanged(gestureRecognizer)
            case timeSliderToProjectsTableTransition:
                 toProjectsTableSwipeHandler!.handleSwipeChanged(gestureRecognizer)
            case toProjectStatsTransition:
                toProjectStatsSwipeHandler!.handleSwipeChanged(gestureRecognizer)
            case projectStatsToProjectsTableTransition:
                projectStatsToProjectsTableSwipeHandler!.handleSwipeChanged(gestureRecognizer)
            default:
                print("Reached a default case in switch. This shouldn't have happen. Search for string: DEFAULT2 in the source code")
            }
        }
        
        if gestureRecognizer.state == .Ended {
            switch(transitionDirection) {
            case toTimeSliderTransition:
                toTimeSliderSwipeHandler!.handleSwipeEnded(gestureRecognizer)
            case timeSliderToProjectsTableTransition:
                toProjectsTableSwipeHandler!.handleSwipeEnded(gestureRecognizer)
            case toProjectStatsTransition:
                toProjectStatsSwipeHandler!.handleSwipeEnded(gestureRecognizer)
            case projectStatsToProjectsTableTransition:
                projectStatsToProjectsTableSwipeHandler!.handleSwipeEnded(gestureRecognizer)
            default:
                print("Reached a default case in switch. This shouldn't have happen. Search for string: DEFAULT3 in the source code")
            }
        }
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer
        if panGestureRecognizer == nil {
            return false
        }
        
        let activeViewController = childViewControllers[0]
        
        if activeViewController as? TimeSliderViewController != nil {
            self.timeSliderVC = activeViewController as? TimeSliderViewController
            return swipeShouldBeginOnTimeSliderVC(panGestureRecognizer!)
        }
        
        if activeViewController as? ProjectsTableViewController != nil {
            return swipeShouldBeginOnProjectsTableVC(panGestureRecognizer!)
        }
        
        if activeViewController as? ProjectStatsViewController != nil {
            return swipeShouldBeginOnProjectStatsVC(panGestureRecognizer!)
        }
        
        return false
    }
    
    private func swipeShouldBeginOnTimeSliderVC(panGestureRecognizer: UIPanGestureRecognizer) -> Bool {
        //we're only interested in a swipe that is left to right and didn't start on any of the controls
        
        let translation = panGestureRecognizer.translationInView(view)
        if fabs(translation.x) < fabs(translation.y) {
            //swipe in the y direction
            return false
        }
        if translation.x <= 0 {
            //swipe is right to left
            return false
        }
        
        let location = panGestureRecognizer.locationInView(timeSliderVC!.view)
        if timeSliderVC!.timeSlider.frame.contains(location) {
            //swipe began inside the slider
            return false
        }
        if timeSliderVC!.startButton.frame.contains(location) {
            //swipe began inside the start button
            return false
        }
        
        //If we made it to here, we're good to go
        self.transitionDirection = timeSliderToProjectsTableTransition
        self.toProjectsTableSwipeHandler =
            TimeSliderToProjectsTableSwipeHandler(fromVC: timeSliderVC!, toVC: projectsTableVC!, containerVC: self)
        return true
    }
    
    private func swipeShouldBeginOnProjectStatsVC(panGestureRecognizer: UIPanGestureRecognizer) -> Bool {
        let translation = panGestureRecognizer.translationInView(view)
        if fabs(translation.x) < fabs(translation.y) {
            //swipe in the y direction
            return false
        }
        if translation.x >= 0 {
            //swipe is left to right
            return false
        }
        self.transitionDirection = projectStatsToProjectsTableTransition
        self.projectStatsToProjectsTableSwipeHandler =
            ProjectStatsToProjectsTableSwipeHandler(fromVC: projectStatsVC!, toVC: projectsTableVC!, containerVC: self)
        return true
    }
    
    private func swipeShouldBeginOnProjectsTableVC(panGestureRecognizer: UIPanGestureRecognizer) -> Bool {
        let translation = panGestureRecognizer.translationInView(view)
        let location = panGestureRecognizer.locationInView(projectsTableVC!.projectsTableView)
        if fabs(translation.x) < fabs(translation.y) {
            //swipe in y direction
            return false
        }
        if translation.x >= 0 {
            //swipe is left to right, so possibly going from projects table to project stats
            let cell = projectsTableVC!.cellAtPoint(location)
            if cell == nil {
                return false
            }
            
            self.transitionDirection = toProjectStatsTransition
            toProjectStatsSwipeHandler = ProjectsTableToProjectStatsSwipeHandler(tableCell: cell!, fromVC: projectsTableVC!, toVC: projectStatsVC!, containerVC: self)
            projectStatsVC!.project = cell!.project
            return true
        }
        let cell = projectsTableVC!.cellAtPoint(location)
        if cell == nil {
            //swipe didn't start on the table cell
            return false
        }
        
        //Create the swipe handler and we're good to go
        self.transitionDirection = toTimeSliderTransition
        toTimeSliderSwipeHandler = ProjectsTableToTimeSliderSwipeHandler(tableCell: cell!,
                fromVC: projectsTableVC!, toVC: timeSliderVC!, containerVC: self)
        timeSliderVC!.project = cell!.project
        return true
    }
    
//MARK: ProjectsTable to TimeSlider swipe
    private func toTimeSliderSwipeBegan(gestureRecognizer:UIPanGestureRecognizer) {
        let location = gestureRecognizer.locationInView(projectsTableVC!.projectsTableView)
        if let cell = projectsTableVC!.cellAtPoint(location) {
            toTimeSliderSwipeHandler = ProjectsTableToTimeSliderSwipeHandler(tableCell: cell,
                fromVC: projectsTableVC!, toVC: timeSliderVC!, containerVC: self)
        }
    }
}




