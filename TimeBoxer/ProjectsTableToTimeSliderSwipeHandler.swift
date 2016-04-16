//
//  ProjectsTableToTimeSliderSwipeHandler.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 06/03/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class ProjectsTableToTimeSliderSwipeHandler: NSObject {
    var tableCell: MyTableViewCell
    var fromView:UIView
    var toView: UIView
    var containerView: UIView
    
    var fromVC: UIViewController
    var toVC: UIViewController
    var containerVC: ContainerViewController
    
    private var tableCellOrigin:CGPoint
    private let drawerSize = CGFloat(50)
    init(tableCell:MyTableViewCell, fromVC: UIViewController, toVC: UIViewController, containerVC: ContainerViewController) {
        self.tableCell = tableCell
        self.tableCellOrigin = tableCell.facadeView.frame.origin
        self.fromView = fromVC.view
        self.fromVC = fromVC
        self.toView = toVC.view
        self.toVC = toVC
        self.containerView = containerVC.view
        self.containerVC = containerVC
    }
    
    func handleSwipeChanged(gestureRecognizer: UIPanGestureRecognizer) {
        
        let translationInProjectsTableView = gestureRecognizer.translationInView(fromView)
        if fabs(translationInProjectsTableView.x) <= drawerSize {
            //animate the table Cell
            if  translationInProjectsTableView.x > 0 {
                //Don't let the user drag the cell in the opposite direction now
                return
            }
            tableCell.facadeView.frame.origin.x = tableCellOrigin.x + translationInProjectsTableView.x
        } else {
            let translation = gestureRecognizer.translationInView(containerView)
            let dx = fabs(translation.x) - drawerSize
            fromView.frame.origin.x = containerView.frame.origin.x - dx
            toView.frame.origin.x = (containerView.frame.origin.x - dx) + containerView.frame.width
            
        }
    }
    
    func handleSwipeEnded(gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translationInView(containerView)
        
        let dx = fabs(translation.x) - drawerSize
        if dx < containerView.frame.width / 2.0  {
            rollbackTransition()
            return
        } else  {
            commitTransition()
        }
        
    }
    
    private func rollbackTransition() {
        
        UIView.animateWithDuration(0.1,
            animations:
            {
                self.tableCell.facadeView.frame.origin.x = self.tableCellOrigin.x
                self.fromView.frame.origin.x = self.containerView.frame.origin.x
                self.toView.frame.origin.x = self.containerView.frame.origin.x + self.containerView.frame.width
            },
            
            completion:
            {
                finished in
                self.toView.removeFromSuperview()
            }
        )
    }
    
    private func commitTransition() {
        UIView.animateWithDuration(0.1,
            animations:
            {
                
                self.toView.frame.origin.x = self.containerView.frame.origin.x
                self.fromView.frame.origin.x = self.containerView.frame.origin.x - self.containerView.frame.width
                
            },
            
            completion:
            {
                finished in
                self.containerVC.addChildViewController(self.toVC)
                self.toVC.didMoveToParentViewController(self.containerVC)
                self.fromVC.willMoveToParentViewController(nil)
                self.fromView.removeFromSuperview()
                self.fromVC.removeFromParentViewController()
                self.tableCell.facadeView.frame.origin.x = self.tableCellOrigin.x
                
        })
    }
}
