//
//  EditProjectToProjectsTableDismissAnimator.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 06/03/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class EditProjectToProjectsTableDismissAnimator: AbstractAnimator {
    override init() {
        super.init()
        self.duration = 0.3
    }
    
    override func doAnimate() {
        print("BEGIN doAnimate")
        let editProjectView = fromView!
        let projectsTableView = toView!
        let containerFrame = container!.frame
        
        projectsTableView.transform = CGAffineTransformMakeTranslation(containerFrame.size.width,0)
        
        container!.addSubview(projectsTableView)
        UIView.animateWithDuration(transitionDuration(context),
            animations: {
                print("BEGIN animations")
                projectsTableView.transform = CGAffineTransformIdentity
                editProjectView.transform = CGAffineTransformMakeTranslation(-self.container!.frame.size.width, 0)
            },
            completion: {
                (finished:Bool) -> Void in
                print("END Segue")
                if self.context!.transitionWasCancelled() {
                    //projectsTableView.removeFromSuperview()
                    self.context!.completeTransition(false)
                } else {
                    editProjectView.removeFromSuperview()
                    self.context!.completeTransition(true)
                    UIApplication.sharedApplication().keyWindow!.addSubview(projectsTableView)
                }
        })
    }
    
    @objc func animationEnded(transitionCompleted: Bool) {
        print("END animation")
    }
}
