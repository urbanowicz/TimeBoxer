//
//  CellSwipeHandler.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 19/04/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class CellSwipeHandler: NSObject {
    var cell: MyTableViewCell
    var leftView: UIView
    var rightView: UIView
    var middleView: UIView
    var containerView: UIView
    
    var leftVC:UIViewController
    var rightVC:UIViewController
    var middleVC:UIViewController
    var containerVC: ContainerViewController
    
    private var cellOrigin:CGPoint
    private var leftViewOrigin:CGPoint
    private var rightViewOrigin:CGPoint
    private var middleViewOrigin:CGPoint
    
    private var drawerSize = CGFloat(50)
    private var animationDuration = 0.2
    private var negativeAcceleration = CGFloat(-100)
    
    init(cell: MyTableViewCell, leftVC: UIViewController, middleVC: UIViewController, rightVC: UIViewController, containerVC: ContainerViewController) {
        self.cell = cell
        self.cellOrigin = cell.facadeView.frame.origin
        self.leftVC = leftVC
        self.leftView = leftVC.view
        self.middleVC = middleVC
        self.middleView = middleVC.view
        self.rightVC = rightVC
        self.rightView = rightVC.view
        self.containerVC = containerVC
        self.containerView = containerVC.view
        self.leftViewOrigin = leftView.frame.origin
        self.middleViewOrigin = middleView.frame.origin
        self.rightViewOrigin = rightView.frame.origin
    }
    
    func handleSwipeBegan(gestureRecognizer: UIPanGestureRecognizer) {
        leftView.frame = containerView.frame
        leftView.frame.origin.x  = containerView.frame.origin.x - containerView.frame.width
        containerView.addSubview(leftView)
        rightView.frame = containerView.frame
        rightView.frame.origin.x = containerView.frame.origin.x + containerView.frame.width
        containerView.addSubview(rightVC.view)
        self.leftViewOrigin = leftView.frame.origin
        self.middleViewOrigin = middleView.frame.origin
        self.rightViewOrigin = rightView.frame.origin
    }
    
    func handleSwipeChanged(gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translationInView(containerView)
        if fabs(translation.x) < drawerSize {
            cell.facadeView.frame.origin.x = cellOrigin.x + translation.x
        } else {
            cell.facadeView.frame.origin.x = translation.x > 0 ? cellOrigin.x + drawerSize : cellOrigin.x - drawerSize
            let dx = translation.x > 0 ? translation.x - drawerSize : translation.x + drawerSize
            leftView.frame.origin.x = leftViewOrigin.x + dx
            middleView.frame.origin.x = middleViewOrigin.x + dx
            rightView.frame.origin.x = rightViewOrigin.x + dx
        }
    }
    
    func handleSwipeEnded(gestureRecognizer: UIPanGestureRecognizer) {
        rollbackTransition()
    }
    
    private func rollbackTransition() {
        UIView.animateWithDuration(animationDuration,
            animations:
            {
                self.cell.facadeView.frame.origin.x = self.cellOrigin.x
                self.leftView.frame.origin.x = self.leftViewOrigin.x
                self.middleView.frame.origin.x = self.middleViewOrigin.x
                self.rightView.frame.origin.x = self.rightViewOrigin.x
            },
            completion:
            {
                finished in
            }
        )
    }

}
