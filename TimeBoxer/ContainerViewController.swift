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
        
    //private var toTimeSliderSwipeHandler:ProjectsTableToTimeSliderSwipeHandler?
    private var timeSliderToProjectsTableSwipeHandler:SwipeHandler?
    //private var toProjectStatsSwipeHandler:ProjectsTableToProjectStatsSwipeHandler?
    private var projectStatsToProjectsTableSwipeHandler:SwipeHandler?
    private var cellSwipeHandler:CellSwipeHandler?
    
    //transition directions
    let fromProjectsTableTransition = 0
    let timeSliderToProjectsTableTransition = 1
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
            
            switch(transitionDirection) {
            case timeSliderToProjectsTableTransition:
                let toVC = projectsTableVC!
                toVC.view.frame = view.frame
                toVC.view.frame.origin.x  = view.frame.origin.x - view.frame.width
                view.addSubview(toVC.view)
            case fromProjectsTableTransition:
                cellSwipeHandler!.handleSwipeBegan(gestureRecognizer)
            case projectStatsToProjectsTableTransition:
                let toVC = projectsTableVC!
                toVC.view.frame = view.frame
                toVC.view.frame.origin.x = view.frame.origin.x + view.frame.width
                view.addSubview(toVC.view)
            default:
                print("Reached a default case in switch. This shouldn't have happen. Search for string: DEFAULT1 in the source code")
            }
            
        }
        
        if gestureRecognizer.state == .Changed {
            switch(transitionDirection) {
            case fromProjectsTableTransition:
                cellSwipeHandler!.handleSwipeChanged(gestureRecognizer)
            case timeSliderToProjectsTableTransition:
                 timeSliderToProjectsTableSwipeHandler!.handleSwipeChanged(gestureRecognizer)
            case projectStatsToProjectsTableTransition:
                projectStatsToProjectsTableSwipeHandler!.handleSwipeChanged(gestureRecognizer)
            default:
                print("Reached a default case in switch. This shouldn't have happen. Search for string: DEFAULT2 in the source code")
            }
        }
        
        if gestureRecognizer.state == .Ended {
            switch(transitionDirection) {
            case fromProjectsTableTransition:
                cellSwipeHandler!.handleSwipeEnded(gestureRecognizer)
            case timeSliderToProjectsTableTransition:
                timeSliderToProjectsTableSwipeHandler!.handleSwipeEnded(gestureRecognizer)
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
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOfGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
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
        
        if timeSliderVC!.startButton.frame.contains(location) {
            //swipe began inside the start button
            return false
        }
        
        //If we made it to here, we're good to go
        self.transitionDirection = timeSliderToProjectsTableTransition
        self.timeSliderToProjectsTableSwipeHandler =
            SwipeHandler(fromVC: timeSliderVC!, toVC: projectsTableVC!, containerVC: self, swipeDirection: .LEFT_TO_RIGHT)
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
            SwipeHandler(fromVC: projectStatsVC!, toVC: projectsTableVC!, containerVC: self, swipeDirection: .RIGHT_TO_LEFT)
        return true
    }
    
    private func swipeShouldBeginOnProjectsTableVC(panGestureRecognizer: UIPanGestureRecognizer) -> Bool {
        let translation = panGestureRecognizer.translationInView(view)
        let location = panGestureRecognizer.locationInView(projectsTableVC!.projectsTableView)
        if fabs(translation.x) < fabs(translation.y) {
            //swipe in y direction
            return false
        }

        let cell = projectsTableVC!.cellAtPoint(location)
        if cell == nil {
            return false
        }
        
        projectStatsVC!.project = cell!.project
        timeSliderVC!.project = cell!.project
        self.transitionDirection = fromProjectsTableTransition

        cellSwipeHandler = CellSwipeHandler(cell: cell!, leftVC: projectStatsVC!, middleVC: projectsTableVC!, rightVC: timeSliderVC!, containerVC: self)
        return true
    }
    
//MARK: Disable auto rotate
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
}




