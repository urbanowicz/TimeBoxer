//
//  AddProjectToProjectsTableDismissAnimator.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 06/03/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class AddProjectToProjectsTableDismissAnimator: AbstractAnimator {
    
    
    override init() {
        super.init()
        self.duration = 0.3
        registerForKeyboardNotifications()
    }
    
    override func doAnimate() {
        let addProjectVC = fromVC! as! AddProjectViewController
        container!.insertSubview(toView!, belowSubview: fromView!)
        addProjectVC.projectNameTextField.resignFirstResponder()
    }
    
    func registerForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:",
            name: UIKeyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let keyboardNotification = KeyboardNotification(notification)
        self.duration = keyboardNotification.animationDuration
        let options = UIViewAnimationOptions(rawValue: UInt(keyboardNotification.animationCurve << 16))
        UIView.animateWithDuration(duration, delay: 0.0, options: options,
            animations: {
                self.fromView!.transform = CGAffineTransformMakeTranslation(0, self.container!.frame.size.height)
            },
            completion: {
                (finished:Bool)->Void in
                self.fromView!.removeFromSuperview()
                self.context!.completeTransition(true)
        })
    }
}
