//
//  ContainerViewController.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 02.01.2016.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController, UIGestureRecognizerDelegate{
    private var originalCenter: CGPoint?

//----------------------------------------------------------------------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //1. Instantiate the opening view controller
        let timeSliderVC =
            storyboard!.instantiateViewControllerWithIdentifier("timeSliderViewController") as!
            TimeSliderViewController
        
        //2. Display the first screen
        displayViewController(timeSliderVC)
        
        //3. Add a Pan Gesture recognizer
        
        let panGestureRecognizer = UIPanGestureRecognizer()
        panGestureRecognizer.addTarget(self, action: "handlePanGesture:")
        view.addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.delegate = self
    }
//----------------------------------------------------------------------------------------------------------------------
    func switchViewControllers(fromVC:UIViewController, toVC:UIViewController, animator:Animator) {
        self.addChildViewController(toVC)
        fromVC.willMoveToParentViewController(nil)
        toVC.view.frame = self.view.frame
        animator.animateTransition(fromVC, toVC: toVC, container: self.view, completion:
        {
            fromVC.removeFromParentViewController()
            toVC.didMoveToParentViewController(self)
            fromVC.removeFromParentViewController()
        })
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
        if gestureRecognizer.state == .Began {
            originalCenter = view.center
        }
        
        if gestureRecognizer.state == .Changed {
            let translation = gestureRecognizer.translationInView(view)
            view.center.x = originalCenter!.x + translation.x
        }
        
        if gestureRecognizer.state == .Ended {
            UIView.animateWithDuration(0.1, animations: {self.view.center.x = self.originalCenter!.x})
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
