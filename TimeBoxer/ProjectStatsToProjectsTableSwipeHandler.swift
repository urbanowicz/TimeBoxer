//
//  ProjectStatsToProjectsTableSwipeHandler.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 16/04/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class ProjectStatsToProjectsTableSwipeHandler: NSObject {
    var fromView:UIView
    var toView: UIView
    var containerView: UIView
    
    var fromVC: UIViewController
    var toVC: UIViewController
    var containerVC: ContainerViewController
    
    init(fromVC: UIViewController, toVC: UIViewController, containerVC: ContainerViewController) {
        self.fromVC = fromVC
        self.toVC = toVC
        self.containerVC = containerVC
        self.fromView = fromVC.view
        self.toView = toVC.view
        self.containerView = containerVC.view
    }
    
    func handleSwipeChanged(gestureRecognizer:UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translationInView(containerView)
        fromView.frame.origin.x = containerView.frame.origin.x + translation.x
        toView.frame.origin.x = containerView.frame.origin.x + containerView.frame.width + translation.x
    }
    
    func handleSwipeEnded(gestureRecognizer:UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translationInView(containerView)
        if fabs(translation.x) >= containerView.frame.width / 2.0 {
            commitTransition()
        } else {
            rollbackTransition()
        }
    }
    
    func commitTransition() {
        UIView.animateWithDuration(0.1,
        animations:
            {
                self.toView.frame.origin.x = self.containerView.frame.origin.x
                self.fromView.frame.origin.x = self.containerView.frame.origin.x - self.containerView.frame.width
                
            },
                                   
        completion:
            {
                finished in
                self.containerVC.addChildViewController(self.toVC)
                self.toVC.didMoveToParentViewController(self.containerVC)
                self.fromVC.willMoveToParentViewController(nil)
                self.fromVC.view.removeFromSuperview()
                self.fromVC.removeFromParentViewController()
                
        })
    }
    
    func rollbackTransition() {
        UIView.animateWithDuration(0.1,
        animations:
            {
                self.fromView.frame.origin.x = self.containerView.frame.origin.x
                self.toView.frame.origin.x = self.containerView.frame.origin.x + self.containerView.frame.width
            },
                                   
        completion:
            {
                finished in
                self.toView.removeFromSuperview()
            }
        )
    }

}
