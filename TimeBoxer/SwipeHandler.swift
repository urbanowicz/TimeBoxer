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
    
    let negativeAcceleration = CGFloat(-1000)
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
        let translation = gestureRecognizer.translationInView(containerView)
        let direction:CGFloat  = swipeDirection == SwipeDirection.LEFT_TO_RIGHT ? 1.0 : -1.0
        if (translation.x * direction >= 0) {
            let translationX = fabs(translation.x)
            fromView.frame.origin.x = containerView.frame.origin.x + translationX * direction
            toView.frame.origin.x = (containerView.frame.origin.x - containerView.frame.width*direction) + (translationX * direction)
        }
    }
    
    func handleSwipeEnded(gestureRecognizer:UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translationInView(containerView)
        let direction:CGFloat  = swipeDirection == SwipeDirection.LEFT_TO_RIGHT ? 1.0 : -1.0
        let startX = translation.x * direction < 0 ? 0 : fabs(translation.x)
        let velocity = gestureRecognizer.velocityInView(containerView).x * direction
        
        var endX = CGFloat(0)
        if velocity > 0 {
            endX = startX - pow(velocity, 2)/(2 * negativeAcceleration)
        } else {
            endX = startX + pow(velocity, 2)/(2 * negativeAcceleration)
        }
        
        if endX >= containerView.frame.width / 2.0 {
            commitTransition()
        } else {
            rollbackTransition()
        }
    }
    
    func commitTransition() {
        UIView.animateWithDuration(animationDuration, delay:0, options:UIViewAnimationOptions.CurveEaseInOut,
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
        UIView.animateWithDuration(animationDuration, delay:0, options:UIViewAnimationOptions.CurveEaseInOut,
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
