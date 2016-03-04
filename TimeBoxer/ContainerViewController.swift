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
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //1. Instantiate the opening view controller
        timeSliderVC =
            storyboard!.instantiateViewControllerWithIdentifier("timeSliderViewController") as?
            TimeSliderViewController
        
        //2. Display the first screen
        displayViewController(timeSliderVC!)
        
        //3. Add a Pan Gesture recognizer
        
        let panGestureRecognizer = UIPanGestureRecognizer()
        panGestureRecognizer.addTarget(self, action: "handlePanGesture:")
        view.addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.delegate = self
        
        //4. Create the Projects Table View
        projectsTableVC =
            storyboard!.instantiateViewControllerWithIdentifier("projectsTableViewController") as?
            ProjectsTableViewController
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
    return true;
}


//MARK: PanGestureRecognizer
    func handlePanGesture(gestureRecognizer: UIPanGestureRecognizer) {
        let currentVC = childViewControllers[0] as? TimeSliderViewController
        
        var fromVC: UIViewController
        var toVC: UIViewController
        var direction:Int // direction == 1 is right to left, direction == -1 is left to right
        
        if currentVC != nil {
            timeSliderVC = currentVC
            fromVC = currentVC!
            toVC = projectsTableVC!
            direction = 1
        } else {
            fromVC = projectsTableVC!
            toVC = timeSliderVC!
            direction = -1
        }
        
        if gestureRecognizer.state == .Began {
            if direction == -1 {
                toTimeSliderSwipeBegan(gestureRecognizer)
            }
            toVC.view.frame = self.view.frame
            toVC.view.frame.origin.x  = self.view.frame.origin.x - view.frame.width * CGFloat(direction)
            self.view.addSubview(toVC.view)
        }
        
        if gestureRecognizer.state == .Changed {
            if direction == -1 {
                toTimeSliderSwipeHandler!.handleSwipeChanged(gestureRecognizer)
            } else {
                let translation = gestureRecognizer.translationInView(view)
                fromVC.view.frame.origin.x = view.frame.origin.x + translation.x
                toVC.view.frame.origin.x = (view.frame.origin.x + translation.x) - view.frame.width * CGFloat(direction)
            }
        }
        
        if gestureRecognizer.state == .Ended {
            let translation = gestureRecognizer.translationInView(view)
            if fabs(translation.x) > view.frame.width / 2.0 {
                
                UIView.animateWithDuration(0.1,
                    animations:
                    {
                        toVC.view.frame.origin.x = self.view.frame.origin.x
                        fromVC.view.frame.origin.x = self.view.frame.origin.x + self.view.frame.width * CGFloat(direction)
                        
                    },
                    
                    completion:
                    {
                        finished in
                        self.addChildViewController(toVC)
                        toVC.didMoveToParentViewController(self)
                        fromVC.willMoveToParentViewController(nil)
                        fromVC.view.removeFromSuperview()
                        fromVC.removeFromParentViewController()
                        

                    })
            } else {
                UIView.animateWithDuration(0.1,
                    animations:
                    {
                        fromVC.view.frame.origin.x = self.view.frame.origin.x
                        toVC.view.frame.origin.x = self.view.frame.origin.x - self.view.frame.width * CGFloat(direction)
                    },
                    
                    completion:
                    {
                        finished in
                        toVC.view.removeFromSuperview()
                    }
                )
            }
        }
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        var swipeDirection = 1
        let activeViewController = childViewControllers[0]
        if activeViewController as? TimeSliderViewController != nil {
            swipeDirection = 1
        } else
            if activeViewController as? ProjectsTableViewController != nil {
                swipeDirection = -1
            } else {
                return false
        }
        
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translationInView(view)
            if fabs(translation.x) > fabs(translation.y) && CGFloat(swipeDirection) * translation.x > 0 {
                return true
            }
            return false
        }
        return false
    }
    
//MARK: ProjectsTable to TimeSlider swipe
    private func toTimeSliderSwipeBegan(gestureRecognizer:UIPanGestureRecognizer) {
        let location = gestureRecognizer.locationInView(projectsTableVC!.projectsTableView)
        if let cell = projectsTableVC!.cellAtPoint(location) {
            toTimeSliderSwipeHandler = ProjectsTableToTimeSliderSwipeHandler(tableCell: cell,
                projectsTableVC: projectsTableVC!, timeSliderVC: timeSliderVC!, containerView: self.view)
        }
    }
    
    private func toTimeSliderSwipeChanged(gesutreRecognizer:UIPanGestureRecognizer) {
        
    }

    private func toTimeSliderSwipeEnded(gestureRecognizer:UIPanGestureRecognizer) {
        
    }
}

private class ProjectsTableToTimeSliderSwipeHandler: NSObject {
    var tableCell: UITableViewCell
    var tableView: UIView
    var fromView:UIView
    var toView: UIView
    var containerView: UIView
    
    private var tableCellOrigin:CGPoint
    init(tableCell:UITableViewCell, projectsTableVC: ProjectsTableViewController, timeSliderVC: TimeSliderViewController, containerView: UIView) {
        self.tableCell = tableCell
        self.tableCellOrigin = tableCell.frame.origin
        self.tableView = projectsTableVC.projectsTableView
        self.fromView = projectsTableVC.view
        self.toView = timeSliderVC.view
        self.containerView = containerView
    }
    
    func handleSwipeChanged(gestureRecognizer: UIPanGestureRecognizer) {
        let drawerSize = CGFloat(50)
        let translationInProjectsTableView = gestureRecognizer.translationInView(tableView)
        if fabs(translationInProjectsTableView.x) <= drawerSize {
            //animate the table Cell
            if  translationInProjectsTableView.x > 0 {
                //Don't let the user drag the cell in the opposite direction now
                return
            }
            print(translationInProjectsTableView.x)
            tableCell.frame.origin.x = tableCellOrigin.x + translationInProjectsTableView.x
        } else {
            let translation = gestureRecognizer.translationInView(containerView)
            let dx = translation.x + drawerSize
            fromView.frame.origin.x = containerView.frame.origin.x + dx
            toView.frame.origin.x = (containerView.frame.origin.x + dx) + containerView.frame.width
            
        }
    }
}
