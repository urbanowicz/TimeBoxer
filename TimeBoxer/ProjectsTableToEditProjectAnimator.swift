//
//  ProjectsTableToEditProjectAnimator.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 06/03/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class ProjectsTableToEditProjectAnimator: AbstractAnimator {
    override init() {
        super.init()
        self.duration = 0.3
    }
    override func doAnimate() {
        let projectsTableView = fromView!
        let editProjectView = toView!
        
        editProjectView.transform = CGAffineTransformMakeTranslation(-container!.frame.size.width, 0)
        container!.addSubview(projectsTableView)
        container!.addSubview(editProjectView)
        UIView.animateWithDuration(transitionDuration(context!),
            animations: {
                editProjectView.transform = CGAffineTransformIdentity
                projectsTableView.transform = CGAffineTransformMakeTranslation(self.container!.frame.size.width, 0)
            },
            completion: {
                (finished:Bool)->Void in
                if self.context!.transitionWasCancelled() {
                    editProjectView.removeFromSuperview()
                    self.context!.completeTransition(false)
                    UIApplication.sharedApplication().keyWindow!.addSubview(projectsTableView)
                } else {
                    //projectsTableView.removeFromSuperview()
                    self.context!.completeTransition(true)
                }
        })
    }
}
