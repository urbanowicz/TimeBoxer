//
//  AbstractSwipeHandler.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 19/04/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class SwipeHandler: NSObject {
    var fromView: UIView
    var toView: UIView
    var containerView: UIView
    var fromVC: UIViewController
    var toVC: UIViewController
    var containerVC: ContainerViewController
    var swipeDirection: SwipeDirection
    
    let negativeAcceleration = CGFloat(-100)
    let animationDuration = 0.2
    
    
    init(fromVC: UIViewController, toVC: UIViewController, containerVC: ContainerViewController, swipeDirection:SwipeDirection) {
        
        self.fromVC = fromVC
        self.toVC = toVC
        self.containerVC = containerVC
        self.fromView = fromVC.view
        self.toView = toVC.view
        self.containerView = containerVC.view
        self.swipeDirection = swipeDirection
    }
    
    func handleSwipeChanged(gestureRecognizer:UIPanGestureRecognizer) {
        let translation = fabs(gestureRecognizer.translationInView(containerView).x)
        let direction:CGFloat  = swipeDirection == SwipeDirection.LEFT_TO_RIGHT ? 1.0 : -1.0
        fromView.frame.origin.x = containerView.frame.origin.x + translation * direction
        toView.frame.origin.x = (containerView.frame.origin.x - containerView.frame.width*direction) + (translation * direction)
    }
    
    func handleSwipeEnded(gestureRecognizer:UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translationInView(containerView)
        let startX = fabs(translation.x)
        let velocity = fabs(gestureRecognizer.velocityInView(containerView).x)
        let endX = startX - pow(velocity, 2)/(2 * negativeAcceleration)
        if endX >= containerView.frame.width / 2.0 {
            commitTransition()
        } else {
            rollbackTransition()
        }
    }
    
    func commitTransition() {
        UIView.animateWithDuration(animationDuration,
            animations:
            {
                let direction:CGFloat  = self.swipeDirection == SwipeDirection.LEFT_TO_RIGHT ? 1.0 : -1.0
                self.toView.frame.origin.x = self.containerView.frame.origin.x
                self.fromView.frame.origin.x = self.containerView.frame.origin.x + self.containerView.frame.width * direction
                
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
        UIView.animateWithDuration(animationDuration,
            animations:
            {
                let direction:CGFloat  = self.swipeDirection == SwipeDirection.LEFT_TO_RIGHT ? 1.0 : -1.0
                self.fromView.frame.origin.x = self.containerView.frame.origin.x
                self.toView.frame.origin.x = self.containerView.frame.origin.x - self.containerView.frame.width * direction
            },
                                   
            completion:
            {
                finished in
                self.toView.removeFromSuperview()
            }
        )
    }
}
