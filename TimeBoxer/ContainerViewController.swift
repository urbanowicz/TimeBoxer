//
//  ContainerViewController.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 02.01.2016.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    var timeSliderVC:TimeSliderViewController?
    var timerRunningVC:TimerRunningViewController?
    var timerPausedVC:TimerPausedViewController?

//----------------------------------------------------------------------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        timeSliderVC =
            storyboard!.instantiateViewControllerWithIdentifier("timeSliderViewController") as?
            TimeSliderViewController
        
        timerRunningVC =
            storyboard!.instantiateViewControllerWithIdentifier("timerRunningViewController") as?
            TimerRunningViewController
        
        timerPausedVC =
            storyboard!.instantiateViewControllerWithIdentifier("timerPausedViewController") as?
            TimerPausedViewController

    }
    
//----------------------------------------------------------------------------------------------------------------------
    private func displayViewController(vc: UIViewController)
    {
        self.addChildViewController(vc)
        vc.view.frame = self.view.frame
        self.view.addSubview(vc.view)
        vc.didMoveToParentViewController(self)
    }

//----------------------------------------------------------------------------------------------------------------------
    private func hideViewController(vc: UIViewController)
    {
        vc.willMoveToParentViewController(nil)
        vc.view.removeFromSuperview()
        vc.removeFromParentViewController()
    }

//----------------------------------------------------------------------------------------------------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}
