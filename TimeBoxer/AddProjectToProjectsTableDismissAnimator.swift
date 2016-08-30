//
//  AddProjectToProjectsTableDismissAnimator.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 06/03/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class AddProjectToProjectsTableDismissAnimator: AbstractAnimator {
    
    var transitionInProgress = false
    override init() {
        super.init()
        self.duration = 0.3
        registerForKeyboardNotifications()
    }
    
    override func doAnimate() {
        transitionInProgress = true
        let addProjectVC = fromVC! as! AddProjectPageViewController
        container!.insertSubview(toView!, belowSubview: fromView!)
        addProjectVC.chooseProjectNameVC.projectNameTextField.resignFirstResponder()
    }
    
    func registerForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddProjectToProjectsTableDismissAnimator.keyboardWillHide(_:)),
            name: UIKeyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if !transitionInProgress {
            print("Hooray")
            return
        }
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
                self.transitionInProgress = false
        })
    }
}
