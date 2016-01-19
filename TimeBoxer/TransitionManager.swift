//
//  TransitionManager.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 28.12.2015.
//  Copyright © 2015 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class TransitionManager: NSObject, UIViewControllerTransitioningDelegate {
    var animator: UIViewControllerAnimatedTransitioning?
    var dismissAnimator: UIViewControllerAnimatedTransitioning?
    var interactiveAnimator:UIViewControllerInteractiveTransitioning?
    var interactiveDismissAnimator:UIViewControllerInteractiveTransitioning?
    
    init(animator: UIViewControllerAnimatedTransitioning?, dismissAnimator: UIViewControllerAnimatedTransitioning?)
    {
        self.animator = animator
        self.dismissAnimator = dismissAnimator
        self.interactiveAnimator = nil
        self.interactiveDismissAnimator = nil
        super.init()
    }
    
    init(animator: UIViewControllerAnimatedTransitioning?, dismissAnimator: UIViewControllerAnimatedTransitioning?,
        interactiveAnimator: UIViewControllerInteractiveTransitioning?,
        interactiveDismissAnimator: UIViewControllerInteractiveTransitioning?)
    {
        self.animator = animator
        self.dismissAnimator = dismissAnimator
        self.interactiveAnimator = interactiveAnimator
        self.interactiveDismissAnimator = interactiveDismissAnimator
        super.init()
    }
    
//----------------------------------------------------------------------------------------------------------------------
     func animationControllerForPresentedController(presented: UIViewController,
        presentingController presenting: UIViewController,
        sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        return animator
    }
    
//----------------------------------------------------------------------------------------------------------------------
    func animationControllerForDismissedController(dismissed: UIViewController)
        -> UIViewControllerAnimatedTransitioning?
    {
        return dismissAnimator
    }
    
//----------------------------------------------------------------------------------------------------------------------
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?
    {
        return interactiveAnimator
    }

//----------------------------------------------------------------------------------------------------------------------
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?
    {
        return interactiveDismissAnimator
    }
}
