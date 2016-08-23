//
//  ContainerViewController.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 02.01.2016.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    private var timeSliderVC:TimeSliderViewController?
    private var projectsTableVC: ProjectsTableViewController?
    private var projectStatsVC: ProjectStatsViewController?
    
    
    //transition directions
    private let fromProjectsTableTransition = 0
    private let timeSliderToProjectsTableTransition = 1
    private let projectStatsToProjectsTableTransition = 3
    private var transitionDirection:Int = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        //2. Create the Time Slider View
        timeSliderVC =
            storyboard!.instantiateViewControllerWithIdentifier("timeSliderViewController") as?
        TimeSliderViewController
        
        //3. Create the Projects Table View
        projectsTableVC =
            storyboard!.instantiateViewControllerWithIdentifier("projectsTableViewController") as?
            ProjectsTableViewController
        displayViewController(projectsTableVC!)
        
        //4. Create the Project Stats View
        projectStatsVC =
            storyboard!.instantiateViewControllerWithIdentifier("projectStatsViewController") as?
            ProjectStatsViewController 
        
    }

    
    func switchViewControllers(fromVC:UIViewController, toVC:UIViewController, animator:Animator?) {
        self.addChildViewController(toVC)
        fromVC.willMoveToParentViewController(nil)
        toVC.view.frame = self.view.frame
        if animator != nil {
            animator!.animateTransition(fromVC, toVC: toVC, container: self.view, completion:
            {
                fromVC.removeFromParentViewController()
                toVC.didMoveToParentViewController(self)
            })
        } else {
            view.addSubview(toVC.view)
            fromVC.view.removeFromSuperview()
            fromVC.removeFromParentViewController()
            toVC.didMoveToParentViewController(self)
        }
    }
    

    private func displayViewController(vc: UIViewController)
    {
        self.addChildViewController(vc)
        vc.view.frame = self.view.frame
        self.view.addSubview(vc.view)
        vc.didMoveToParentViewController(self)
    }
    


    private func hideViewController(vc: UIViewController)
    {
        vc.willMoveToParentViewController(nil)
        vc.view.removeFromSuperview()
        vc.removeFromParentViewController()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }    

    
//MARK: Disable auto rotate
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
}




