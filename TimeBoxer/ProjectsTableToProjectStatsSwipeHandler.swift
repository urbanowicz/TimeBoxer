//
//  ProjectsTableToProjectStatsSwipeHandler.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 16/04/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class ProjectsTableToProjectStatsSwipeHandler: NSObject {
    var tableCell: MyTableViewCell
    var fromView:UIView
    var toView:UIView
    var containerView: UIView

    var fromVC: UIViewController
    var toVC: UIViewController
    var containerVC: ContainerViewController
    
    private var tableCellOrigin:CGPoint
    private let drawerSize = CGFloat(50)
    
    init(tableCell: MyTableViewCell, fromVC: UIViewController, toVC: UIViewController, containerVC: ContainerViewController) {
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
        print ("To ProjectStatsVC swipe changed")
    }
    
    func handleSwipeEnded(gestureRecognizer: UIPanGestureRecognizer) {
        print ("To ProjectStatsVC swipe ended")
    }
}
