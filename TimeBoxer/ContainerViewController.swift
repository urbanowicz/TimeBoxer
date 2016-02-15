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
        

//----------------------------------------------------------------------------------------------------------------------
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
//----------------------------------------------------------------------------------------------------------------------
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
            fromVC.removeFromParentViewController()
            toVC.didMoveToParentViewController(self)
        }
    }
    
//----------------------------------------------------------------------------------------------------------------------
    private func displayViewController(vc: UIViewController)
    {
        self.addChildViewController(vc)
        vc.view.frame = self.view.frame
        self.view.addSubview(vc.view)
        vc.didMoveToParentViewController(self)
    }
    

//----------------------------------------------------------------------------------------------------------------------
    private func hideViewController(vc: UIViewController)
    {
        vc.willMoveToParentViewController(nil)
        vc.view.removeFromSuperview()
        vc.removeFromParentViewController()
    }

//----------------------------------------------------------------------------------------------------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
//----------------------------------------------------------------------------------------------------------------------
//MARK: PanGestureRecognizer
    func handlePanGesture(gestureRecognizer: UIPanGestureRecognizer) {
        timeSliderVC = childViewControllers[0] as? TimeSliderViewController
        if timeSliderVC == nil {
            return
        }
        if gestureRecognizer.state == .Began {
            projectsTableVC!.view.frame = self.view.frame
            projectsTableVC!.view.frame.origin.x  = self.view.frame.origin.x - view.frame.width
            self.view.addSubview(projectsTableVC!.view)
        }
        
        if gestureRecognizer.state == .Changed {
            let translation = gestureRecognizer.translationInView(view)
            timeSliderVC!.view.frame.origin.x = view.frame.origin.x + translation.x
            projectsTableVC!.view.frame.origin.x = (view.frame.origin.x + translation.x) - view.frame.width
        }
        
        if gestureRecognizer.state == .Ended {
            let translation = gestureRecognizer.translationInView(view)
            if translation.x > view.frame.width / 2.0 {
                
                UIView.animateWithDuration(0.1,
                    animations:
                    {
                        self.projectsTableVC!.view.frame.origin.x = self.view.frame.origin.x
                        self.timeSliderVC!.view.frame.origin.x = self.view.frame.origin.x + self.view.frame.width
                        
                    },
                    
                    completion:
                    {
                        finished in
                        self.addChildViewController(self.projectsTableVC!)
                        self.projectsTableVC!.didMoveToParentViewController(self)
                        self.timeSliderVC!.willMoveToParentViewController(nil)
                        self.timeSliderVC!.view.removeFromSuperview()
                        self.timeSliderVC!.removeFromParentViewController()
                        

                    })
            } else {
                UIView.animateWithDuration(0.1,
                    animations:
                    {
                        self.timeSliderVC!.view.frame.origin.x = self.view.frame.origin.x
                        self.projectsTableVC!.view.frame.origin.x = self.view.frame.origin.x - self.view.frame.width
                    },
                    
                    completion:
                    {
                        finished in
                        self.projectsTableVC!.view.removeFromSuperview()
                    }
                )
            }
        }
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translationInView(view)
            if fabs(translation.x) > fabs(translation.y) && translation.x > 0 {
                return true
            }
            return false
        }
        return false
    }


}
