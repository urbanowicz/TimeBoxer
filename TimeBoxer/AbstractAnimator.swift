//
//  AbstractAnimator2.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 24/01/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class AbstractAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var fromVC: UIViewController?
    var toVC: UIViewController?
    var fromView: UIView?
    var toView: UIView?
    var container: UIView?
    var context: UIViewControllerContextTransitioning?
    var duration:NSTimeInterval = 0.3
    var fromViewControllerInitialFrame:CGRect?
    var toViewControllerInitialFrame:CGRect?
    var fromViewControllerFinalFrame:CGRect?
    var toViewControllerFinalFrame:CGRect?
    
    override init() {
        super.init()
    }
    
    @objc func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    @objc func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        initFields(transitionContext)
        doAnimate()
    }
    
    private func initFields(context: UIViewControllerContextTransitioning) {
        self.context = context
        fromVC = context.viewControllerForKey(UITransitionContextFromViewControllerKey)
        toVC = context.viewControllerForKey(UITransitionContextToViewControllerKey)
        fromView = context.viewForKey(UITransitionContextFromViewKey)
        if fromView == nil {
            fromView = fromVC!.view
        }
        toView = context.viewForKey(UITransitionContextToViewKey)
        if toView == nil {
            toView = toVC!.view
        }
        container = context.containerView()
        fromViewControllerInitialFrame = context.initialFrameForViewController(fromVC!)
        fromViewControllerFinalFrame = context.finalFrameForViewController(fromVC!)
        toViewControllerInitialFrame = context.initialFrameForViewController(toVC!)
        toViewControllerFinalFrame = context.finalFrameForViewController(toVC!)
        
    }
    
    func doAnimate() {
        //implemented in subclasses
    }
}
