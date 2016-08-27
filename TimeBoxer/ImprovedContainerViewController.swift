//
//  ImprovedContainerViewController.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 13/08/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class ImprovedContainerViewController: UIViewController, ScrollingCellDelegate, UIScrollViewDelegate {

    private var projectStatsVC: ProjectStatsViewController!
    private var projectsTableVC: ProjectsTableViewController!
    private var timeSliderVC: TimeSliderViewController!
    private var scrollView: UIScrollView!
    
    private var lastSelectedCell:MyTableViewCell?
    private var defaultOffset:CGFloat = 0
    
    private var vcStack = [UIViewController]()
    private var currentVC:UIViewController? {
        get {
            return vcStack.last
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        instantiateChildViewControllers()
        
        let screenSize = UIScreen.mainScreen().bounds.size
        setupChildController(projectStatsVC, withSize: screenSize, origin: CGPointMake(0, 0))
        setupChildController(projectsTableVC, withSize: screenSize, origin:CGPointMake(screenSize.width,0))
        setupChildController(timeSliderVC, withSize: screenSize, origin: CGPointMake(2*screenSize.width,0))
    }
    
    private func setupScrollView() {
        let screenSize = UIScreen.mainScreen().bounds.size
        defaultOffset = screenSize.width
        scrollView = UIScrollView()
        scrollView.frame = CGRect(origin: CGPointZero, size: screenSize)
        scrollView.contentSize = CGSizeMake(screenSize.width*3, screenSize.height)
        scrollView.contentOffset = CGPointMake(defaultOffset,0)
        scrollView.directionalLockEnabled = true
        scrollView.pagingEnabled = true
        scrollView.bounces = false
        scrollView.scrollEnabled = false
        scrollView.delegate = self
        view.addSubview(scrollView)
    }
    
    private func instantiateChildViewControllers() {
        projectStatsVC =
            storyboard!.instantiateViewControllerWithIdentifier("projectStatsViewController") as!
        ProjectStatsViewController
        
        projectsTableVC =
            storyboard!.instantiateViewControllerWithIdentifier("projectsTableViewController") as!
        ProjectsTableViewController
        vcStack.append(projectsTableVC)
        
        timeSliderVC = storyboard!.instantiateViewControllerWithIdentifier("timeSliderViewController") as?
        TimeSliderViewController
    }
    
    private func setupChildController(child: UIViewController, withSize size:CGSize, origin:CGPoint) {
        addChildViewController(child)
        child.view.frame = CGRect(origin: origin, size: size)
        scrollView.addSubview(child.view)
        child.didMoveToParentViewController(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func pushViewController(vc:UIViewController, animator:Animator?) {
        addChildViewController(vc)
        vc.view.frame = view.frame
        if animator != nil {
            animator!.animateTransition(currentVC!, toVC: vc, container: self.view, completion:
                {
                    self.vcStack.append(vc)
                    vc.didMoveToParentViewController(self)
                    
            })
        } else {
            self.vcStack.append(vc)
            view.addSubview(vc.view)
            vc.didMoveToParentViewController(self)
        }
    }
    
    func popViewController(animator:Animator?) {
        let fromVC = vcStack.popLast()!
        let toVC = currentVC!
        fromVC.willMoveToParentViewController(nil)
        if animator != nil {
            animator!.animateTransition(fromVC, toVC: toVC, container: view, completion: {
                fromVC.removeFromParentViewController()
            })
        } else {
            fromVC.view.removeFromSuperview()
            fromVC.removeFromParentViewController()
        }
    }
    
    func replaceViewController(withVC vc:UIViewController, animator:Animator?) {
        let fromVC = vcStack.popLast()!
        fromVC.willMoveToParentViewController(nil)
        addChildViewController(vc)
        vc.view.frame = view.frame
        if animator != nil {
            animator!.animateTransition(fromVC, toVC: vc, container: self.view, completion:
                {
                    self.vcStack.append(vc)
                    vc.didMoveToParentViewController(self)
                    fromVC.removeFromParentViewController()
            })
        } else {
            self.vcStack.append(vc)
            vc.didMoveToParentViewController(self)
            fromVC.view.removeFromSuperview()
            fromVC.removeFromParentViewController()
        }
    }
    
    //MARK: ScrollingCellDelegate
    func scrollingCellDidBeginPulling(cell:MyTableViewCell) {
        //if cell != lastSelectedCell {
            projectStatsVC.prepareViewForUse(withProject: cell.project!)
            timeSliderVC.prepareViewForUse(withProject: cell.project!)
            lastSelectedCell = cell
        //}
    }
    func scrollingCellDidChangePullOffset(offset:CGFloat) {
        scrollView.contentOffset = CGPointMake(defaultOffset + offset, 0)
    }
    func scrollingCellDidEndPulling(cell:MyTableViewCell) {
        if scrollView.contentOffset.x == defaultOffset {
            scrollView.scrollEnabled = false
        } else {
            scrollView.scrollEnabled = true
            if scrollView.contentOffset.x == defaultOffset * 2 {
                vcStack.removeLast()
                vcStack.append(timeSliderVC)
            }
            if scrollView.contentOffset.x == 0 {
                vcStack.removeLast()
                vcStack.append(projectStatsVC)
            }
        }
    }
    
    //MARK: UIScrollViewDelegate
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if targetContentOffset.memory.x == defaultOffset {
            scrollView.scrollEnabled = false
            vcStack.removeLast()
            vcStack.append(projectsTableVC)
        }
    }
    
    
    //MARK: Disable auto rotate
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    //MARK: Hide status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    //MARK: Private functions
    
}


