//
//  AddProjectToProjectsTableDismissAnimator.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 06/03/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class AddProjectToProjectsTableDismissAnimator: AbstractAnimator {
    private let keyboardAnimationCurveRawValue = UInt(458752)
    override init() {
        super.init()
        self.duration = 0.3
    }
    
    override func doAnimate() {
        self.container?.insertSubview(toView!, belowSubview: fromView!)
        let options = UIViewAnimationOptions(rawValue: self.keyboardAnimationCurveRawValue)
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
