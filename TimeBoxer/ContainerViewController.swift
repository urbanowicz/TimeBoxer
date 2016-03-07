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
        
    private var toTimeSliderSwipeHandler:ProjectsTableToTimeSliderSwipeHandler?
    private var toProjectsTableSwipeHandler:TimeSliderToProjectsTableSwipeHandler?
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //1. Add a Pan Gesture recognizer
        let panGestureRecognizer = UIPanGestureRecognizer()
        panGestureRecognizer.addTarget(self, action: "handlePanGesture:")
        view.addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.delegate = self
        
        //2. Instantiate the opening view controller
        timeSliderVC =
            storyboard!.instantiateViewControllerWithIdentifier("timeSliderViewController") as?
        TimeSliderViewController
        
        //3. Create the Projects Table View
        projectsTableVC =
            storyboard!.instantiateViewControllerWithIdentifier("projectsTableViewController") as?
            ProjectsTableViewController
        displayViewController(projectsTableVC!)
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
        
        var toVC: UIViewController
        let toTimeSlider = -1
        let toProjectsTable = 1
        var direction:Int
        
        let currentVC = childViewControllers[0] as? TimeSliderViewController
        if currentVC != nil {
            toVC = projectsTableVC!
            direction = toProjectsTable
        } else {
            toVC = timeSliderVC!
            direction = toTimeSlider
        }
        
        if gestureRecognizer.state == .Began {
            toVC.view.frame = self.view.frame
            toVC.view.frame.origin.x  = self.view.frame.origin.x - view.frame.width * CGFloat(direction)
            self.view.addSubview(toVC.view)
        }
        
        if gestureRecognizer.state == .Changed {
            if direction == toTimeSlider {
                toTimeSliderSwipeHandler!.handleSwipeChanged(gestureRecognizer)
            }
            if direction == toProjectsTable {
                toProjectsTableSwipeHandler!.handleSwipeChanged(gestureRecognizer)
            }
        }
        
        if gestureRecognizer.state == .Ended {
            if direction == toTimeSlider {
                toTimeSliderSwipeHandler!.handleSwipeEnded(gestureRecognizer)
            }
            if direction == toProjectsTable {
                toProjectsTableSwipeHandler!.handleSwipeEnded(gestureRecognizer)
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
        
        return false
    }
    
    private func swipeShouldBeginOnTimeSliderVC(panGestureRecognizer: UIPanGestureRecognizer) -> Bool {
        //we're only interested in a swipe that is left to right and didn't start on any of the controls
        
        let translation = panGestureRecognizer.translationInView(view)
        if fabs(translation.x) < fabs(translation.y) {
            //swipe in the y direction
            return false
        }
        if translation.x < 0 {
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
        self.toProjectsTableSwipeHandler =
            TimeSliderToProjectsTableSwipeHandler(fromVC: timeSliderVC!, toVC: projectsTableVC!, containerVC: self)
        return true
    }
    
    private func swipeShouldBeginOnProjectsTableVC(panGestureRecognizer: UIPanGestureRecognizer) -> Bool {
        let translation = panGestureRecognizer.translationInView(view)
        if fabs(translation.x) < fabs(translation.y) {
            //swipe in y direction
            return false
        }
        if translation.x > 0 {
            //swipe is left to right
            return false
        }
        let location = panGestureRecognizer.locationInView(projectsTableVC!.projectsTableView)
        let cell = projectsTableVC!.cellAtPoint(location)
        if cell == nil {
            //swipe didn't start on the table cell
            return false
        }
        
        //Create the swipe handler and we're good to go
        toTimeSliderSwipeHandler = ProjectsTableToTimeSliderSwipeHandler(tableCell: cell!,
                fromVC: projectsTableVC!, toVC: timeSliderVC!, containerVC: self)
        timeSliderVC!.projectName = cell!.project!.name
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




