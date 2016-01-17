//
//  AbstractAnimator.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 17/01/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class AbstractAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var fromVC: UIViewController?
    var toVC: UIViewController?
    var container: UIView?
    var context: UIViewControllerContextTransitioning?
    var duration:NSTimeInterval
    
    let defaultDuration = 0.3
    
    override init() {
        self.duration = defaultDuration
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
        self.fromVC = context.viewControllerForKey(UITransitionContextFromViewControllerKey)
        self.toVC = context.viewControllerForKey(UITransitionContextToViewControllerKey)
        self.container = context.containerView()
    }
    
    func doAnimate() {
        //implemented in subclasses
    }

}
