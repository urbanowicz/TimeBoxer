//
//  SlideUpAndDownAnimator.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 30/10/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class SlideUpAndDownAnimator: NSObject, POPAnimationDelegate, Animator {
    let transitionDuration = 0.3

    
    func animateTransition(fromVC: UIViewController, toVC: UIViewController, container: UIView, completion: (() -> Void)?) {
        let fromView = fromVC.view
        
        if (toVC.view.superview == nil) {
            container.insertSubview(toVC.view, belowSubview: fromVC.view)
        }
        
        UIView.animateWithDuration(transitionDuration, animations: {
                fromView.frame.origin.y = container.frame.size.height
            },
            completion: {finished in
                fromView.removeFromSuperview()
                if let executeCompletionBlock = completion  {
                    executeCompletionBlock()
                }
        })
    }
}
