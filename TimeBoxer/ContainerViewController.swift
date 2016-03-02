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
            toVC.view.frame = self.view.frame
            toVC.view.frame.origin.x  = self.view.frame.origin.x - view.frame.width * CGFloat(direction)
            self.view.addSubview(toVC.view)
        }
        
        if gestureRecognizer.state == .Changed {
            let translation = gestureRecognizer.translationInView(view)
            fromVC.view.frame.origin.x = view.frame.origin.x + translation.x
            toVC.view.frame.origin.x = (view.frame.origin.x + translation.x) - view.frame.width * CGFloat(direction)
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


}
