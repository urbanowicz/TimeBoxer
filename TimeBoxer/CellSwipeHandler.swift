//
//  CellSwipeHandler.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 19/04/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class CellSwipeHandler: NSObject {
    var cell: MyTableViewCell!
    var leftView: UIView!
    var rightView: UIView!
    var middleView: UIView!
    var containerView: UIView!
    
    var leftVC:UIViewController!
    var rightVC:UIViewController!
    var middleVC:UIViewController!
    var containerVC: ContainerViewController!
    
    private var cellOrigin:CGPoint!
    private var leftViewOrigin:CGPoint!
    private var rightViewOrigin:CGPoint!
    private var middleViewOrigin:CGPoint!
    
    private var drawerSize = CGFloat(50)
    private var animationDuration = 0.2
    private var negativeAcceleration = CGFloat(1000)
    
    override init() {
        super.init()
    }
    
    func setup(cell: MyTableViewCell, leftVC: UIViewController, middleVC: UIViewController, rightVC: UIViewController, containerVC: ContainerViewController) {
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
        let translation = gestureRecognizer.translationInView(containerView)
        let startX = translation.x
        let velocity = gestureRecognizer.velocityInView(containerView)
        var accelerationMultiplier = CGFloat(1)
        if velocity.x * startX < 0 {
            accelerationMultiplier = 100
        }
        let dx = pow(velocity.x, 2) / (2 * self.negativeAcceleration * accelerationMultiplier)
        var endX = startX
        if velocity.x < 0 {
            endX -= dx
        } else {
            endX += dx
        }
        
        if fabs(endX) < drawerSize {
            cell.facadeView.frame.origin.x = cellOrigin.x + endX
        } else {
            cell.facadeView.frame.origin.x = endX > 0 ? cellOrigin.x + drawerSize : cellOrigin.x - drawerSize
        }
        
        if fabs(endX) >= containerView.frame.width / 2.0 {
            if endX > 0 {
                commitToLeftViewTransition()
            } else {
                commitToRightViewTransition()
            }
        } else {
            rollbackTransition()
        }
    }
    
    private func commitToRightViewTransition() {
        
        UIView.animateWithDuration(animationDuration, delay:0, options:UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                self.rightView.frame.origin.x = self.containerView.frame.origin.x
                self.middleView.frame.origin.x = self.containerView.frame.origin.x - self.containerView.frame.width
                self.leftView.frame.origin.x = self.containerView.frame.origin.x - 2*self.containerView.frame.width
                self.cell.facadeView.frame.origin.x = self.cellOrigin.x
            },
            completion: {
                finished in
                self.containerVC.addChildViewController(self.rightVC)
                self.rightVC.didMoveToParentViewController(self.containerVC)
                self.middleVC.willMoveToParentViewController(nil)
                self.middleView.removeFromSuperview()
                self.middleVC.removeFromParentViewController()
                self.leftVC.willMoveToParentViewController(nil)
                self.leftView.removeFromSuperview()
                self.leftVC.removeFromParentViewController()
            })
    }
    
    private func commitToLeftViewTransition() {
        UIView.animateWithDuration(animationDuration, delay:0, options:UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                self.leftView.frame.origin.x = self.containerView.frame.origin.x
                self.middleView.frame.origin.x = self.containerView.frame.origin.x + self.containerView.frame.width
                self.rightView.frame.origin.x = self.containerView.frame.origin.x + 2*self.containerView.frame.width
                self.cell.facadeView.frame.origin.x = self.cellOrigin.x
            },
            completion: {
                finished in
                self.containerVC.addChildViewController(self.leftVC)
                self.leftVC.didMoveToParentViewController(self.containerVC)
                self.middleVC.willMoveToParentViewController(nil)
                self.middleView.removeFromSuperview()
                self.middleVC.removeFromParentViewController()
                self.rightVC.willMoveToParentViewController(nil)
                self.rightView.removeFromSuperview()
                self.rightVC.removeFromParentViewController()
            }
        )
    }
    
    private func rollbackTransition() {
        UIView.animateWithDuration(animationDuration, delay:0, options:UIViewAnimationOptions.CurveEaseInOut,
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
                self.leftView.removeFromSuperview()
                self.rightView.removeFromSuperview()
            }
        )
    }

}
