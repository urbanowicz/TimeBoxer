//
//  ShrinkingCircleAnimator.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 04/03/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit


class ShrinkingCircleAnimator:NSObject, Animator, CAAnimationDelegate {
    let transitionDuration = 0.25
    var fromVC:UIViewController?
    var toVC:UIViewController?
    var container:UIView?
    var completionBlock: (() -> Void)?
    var circleCenter:CGPoint
    var circlesParentView:UIView
    
    init(circleCenter:CGPoint, parentView: UIView) {
        self.circleCenter = circleCenter
        circlesParentView = parentView
    }
    
    func animateTransition(fromVC: UIViewController, toVC: UIViewController, container: UIView, completion: (() -> Void)?)
    {
        //Remember: Container is the actual view of the parent controller.
        //It already contains the fromVC.view.
        //It is the animator's responsibility to remove the fromVC.view and insert the toVC.view
        
        //1. Store the parameters as instance variables
        self.fromVC = fromVC
        self.toVC = toVC
        self.container = container
        self.completionBlock = completion
        
        //2. Insert the toVC.view under the fromVC.view so that we can uncover it during the animation
        if toVC.view.superview == nil {
            container.insertSubview(toVC.view, belowSubview: fromVC.view)
        }
        //3. Prepare the shrinking circle layer and set it as fromVC mask layer
        let shrinkingCircleLayer = prepareShrinkingCircleAnimationLayer()
        fromVC.view.layer.mask = shrinkingCircleLayer
    }
    
    
    @objc func animationDidStop(anim: CAAnimation, finished flag: Bool)
    {
        //Done with the animation. Do the cleanup.
        fromVC!.view.removeFromSuperview()
        fromVC!.view.layer.mask = nil
        if let executeCompletionBlock = completionBlock {
            executeCompletionBlock()
        }
    }
    
    
    private func prepareShrinkingCircleAnimationLayer() -> CALayer
    {
        let animationLayer = CAShapeLayer()
        let actualCircleCenter = container!.convertPoint(circleCenter, fromView: circlesParentView)
        let smallCirclePath = CirclePathWrapper(centerX: actualCircleCenter.x, centerY: actualCircleCenter.y,
            radius: 0.0).path
        let largeCirclePath = createLargeCircle(actualCircleCenter).path
        animationLayer.path = smallCirclePath
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.delegate = self
        animation.duration = transitionDuration
        animation.fromValue = largeCirclePath
        animation.toValue = smallCirclePath
        animationLayer.addAnimation(animation, forKey: "path")
        return animationLayer
    }
    
    
    private func createLargeCircle(actualCircleCenter: CGPoint) -> CirclePathWrapper
    {
        
        let xs = actualCircleCenter.x
        let ys = actualCircleCenter.y
        let x0 = container!.frame.origin.x
        let y0 = container!.frame.origin.y
        let  largeRadius = sqrt(pow((xs - x0),2) + pow((ys - y0),2))
        return CirclePathWrapper(centerX: xs, centerY: ys, radius: largeRadius)
    }
}
