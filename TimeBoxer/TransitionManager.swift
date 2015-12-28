//
//  TransitionManager.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 28.12.2015.
//  Copyright © 2015 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class TransitionManager: NSObject, UIViewControllerTransitioningDelegate {
    var animator: UIViewControllerAnimatedTransitioning
    var dismissAnimator: UIViewControllerAnimatedTransitioning
    
    init(animator: UIViewControllerAnimatedTransitioning, dismissAnimator: UIViewControllerAnimatedTransitioning)
    {
        self.animator = animator
        self.dismissAnimator = dismissAnimator
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
}
