//
//  ProjectsTableCellPanGestureRecognizer.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 10/03/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class ProjectsTableCellPanGestureDelegate: UIView, UIGestureRecognizerDelegate  {
    var tableCell:MyTableViewCell?
    var projectsTableVC:ProjectsTableViewController?
    
    private var segueStarted:Bool = false
    private var facadeOrigin:CGPoint?
    
    func handlePan(recognizer: UIPanGestureRecognizer) {
        let drawerSize = CGFloat(50)
        let projectsTableView = tableCell!.superview!
        let transitionManager = projectsTableVC!.toEditProjectTransitionManager
        if recognizer.state == .Began {
            facadeOrigin = tableCell!.facadeView.frame.origin
            segueStarted = false
        }
        if recognizer.state == .Changed {
            
            let translation = recognizer.translationInView(projectsTableView)
            if translation.x < drawerSize {
                if segueStarted {
                    transitionManager.interactiveAnimator!.cancelInteractiveTransition()
                    segueStarted = false
                }
                tableCell!.facadeView.frame.origin.x = facadeOrigin!.x + translation.x
            } else {
                if !segueStarted {
                    projectsTableVC!.performSegueWithIdentifier("ProjectsTableToEditProject", sender: tableCell)
                    segueStarted = true
                }
                let dx:CGFloat = (translation.x - drawerSize) / projectsTableView.frame.width
                transitionManager.interactiveAnimator!.updateInteractiveTransition(dx)
            }
        }
        if recognizer.state == .Ended {
            if !segueStarted {
                UIView.animateWithDuration(0.2, animations: {self.tableCell!.facadeView.frame.origin.x = self.facadeOrigin!.x})
            } else {
                let translation = recognizer.translationInView(projectsTableView)
                if translation.x - drawerSize > (projectsTableView.frame.width/2.0) {
                    transitionManager.interactiveAnimator!.finishInteractiveTransition()
                } else {
                    transitionManager.interactiveAnimator!.cancelInteractiveTransition()
                    
                    
                }
                UIView.animateWithDuration(0.1, animations: {self.tableCell!.facadeView.frame.origin.x = self.facadeOrigin!.x})
                segueStarted = false
            }
        }
    }
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        let projectsTableView = tableCell!.superview!
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translationInView(projectsTableView)
            if fabs(translation.x) > fabs(translation.y) && translation.x > 0 {
                return true
            }
            return false
        }
        return false
    }
}
