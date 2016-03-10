//
//  ProjectsTableCellPanGestureRecognizer.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 10/03/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class ProjectsTableCellPanGestureDelegate: UIView, UIGestureRecognizerDelegate  {
    var projectsTableView:UITableView?
    var tableCell:MyTableViewCell?
    var projectsTableVC:UIViewController?
    var transitionManager:TransitionManager?
    
    private var segueStarted:Bool = false
    private var originalCenter:CGPoint?
    
    func handlePan(recognizer: UIPanGestureRecognizer) {
        let drawerSize = CGFloat(50)
        if recognizer.state == .Began {
            originalCenter = tableCell!.center
            segueStarted = false
        }
        if recognizer.state == .Changed {
            let translation = recognizer.translationInView(projectsTableView!)
            if translation.x < drawerSize {
                if segueStarted {
                    transitionManager!.interactiveAnimator!.cancelInteractiveTransition()
                    segueStarted = false
                }
                tableCell!.center.x = originalCenter!.x + translation.x
            } else {
                if !segueStarted {
                    projectsTableVC!.performSegueWithIdentifier("ProjectsTableToEditProject", sender: tableCell)
                    segueStarted = true
                }
                let dx:CGFloat = (translation.x - drawerSize) / projectsTableView!.frame.width
                transitionManager!.interactiveAnimator!.updateInteractiveTransition(dx)
            }
        }
        if recognizer.state == .Ended {
            if !segueStarted {
                UIView.animateWithDuration(0.2, animations: {self.tableCell!.center.x = self.originalCenter!.x})
            } else {
                let translation = recognizer.translationInView(self.projectsTableView!)
                if translation.x - drawerSize > (self.projectsTableView!.frame.width/2.0) {
                    transitionManager!.interactiveAnimator!.finishInteractiveTransition()
                } else {
                    transitionManager!.interactiveAnimator!.cancelInteractiveTransition()
                    
                    
                }
                UIView.animateWithDuration(0.1, animations: {self.tableCell!.center.x = self.originalCenter!.x})
                segueStarted = false
            }
        }
    }
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translationInView(projectsTableView!)
            if fabs(translation.x) > fabs(translation.y) && translation.x > 0 {
                return true
            }
            return false
        }
        return false
    }
}
