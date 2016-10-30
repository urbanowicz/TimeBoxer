//
//  FadeInAnimator.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 04/03/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class FadeInAnimator:NSObject, Animator {
    let transitionDuration = 0.3
    
    func animateTransition(fromVC: UIViewController, toVC: UIViewController, container: UIView, completion: (() -> Void)?) {
        //Remember: Container is the actual view of the parent controller.
        //It already contains the fromVC.view.
        //It is the animator's responsibility to remove the fromVC.view and insert the toVC.view
        
        
        //Prepare the toVC.view to be faded in
        
        if (toVC.view.superview == nil) {
            toVC.view.alpha = 0.0
            container.addSubview(toVC.view)
        }
        
        UIView.animateWithDuration(transitionDuration,
            animations: { toVC.view.alpha = 1.0
            fromVC.view.alpha = 0.0} ,
            completion: {
                finished in
                fromVC.view.removeFromSuperview()
                if let executeCompletionBlock = completion {
                    executeCompletionBlock()
                }
            }
        )
    }
}
