//
//  ProjectsTableToAddProjectAnimator.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 06/03/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class ProjectsTableToAddProjectAnimator: AbstractAnimator {
    private let keyboardAnimationCurveRawValue = UInt(458752)
    
    override init() {
        super.init()
        self.duration = 0.3
    }
    
    override func doAnimate() {
        toView!.transform = CGAffineTransformMakeTranslation(0, container!.frame.size.height)
        container!.addSubview(toView!)
        let options = UIViewAnimationOptions(rawValue: self.keyboardAnimationCurveRawValue)
        UIView.animateWithDuration(duration, delay:0.0, options: options, animations: {
            self.toView!.transform = CGAffineTransformIdentity
            }, completion: {
                (finished: Bool) -> Void in
                self.context!.completeTransition(true)
        })
    }
}

