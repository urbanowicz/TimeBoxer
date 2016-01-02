//
//  TimerPausedViewController.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 05.11.2015.
//  Copyright © 2015 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class TimerPausedViewController: UIViewController {
    @IBOutlet weak var pausedLabel: UILabel!
    @IBOutlet weak var topContainer: UIView!
    @IBOutlet weak var toolbarFiller: UIView!
    @IBOutlet weak var resumeButton: StartButton!
    @IBOutlet weak var cancelButton: CancelButton!
    @IBOutlet weak var stopButton: StopButton!
//----------------------------------------------------------------------------------------------------------------------

    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red:0.15, green:0.15, blue:0.15, alpha:1.0)
        topContainer.backgroundColor = UIColor(red:0.15, green:0.15, blue:0.15, alpha:1.0)
        toolbarFiller.backgroundColor = UIColor(red:0.15, green:0.15, blue:0.15, alpha:1.0)
        pausedLabel.textColor = UIColor(red:1.0, green:0.945, blue: 0.902, alpha:1.0)
        
        resumeButton.ovalLayerColor = UIColor(red:1.0, green:0.945, blue: 0.902, alpha:1.0)
        resumeButton.frontLayerColor = UIColor(red:0.15, green:0.15, blue:0.15, alpha:1.0)
        resumeButton.borderWidth = 0.0
        
        cancelButton.ovalLayerColor = resumeButton.ovalLayerColor
        cancelButton.frontLayerColor = resumeButton.frontLayerColor
        cancelButton.borderWidth = 0.0
        
        stopButton.ovalLayerColor = cancelButton.ovalLayerColor
        stopButton.frontLayerColor = cancelButton.frontLayerColor
        stopButton.borderWidth = 0.0
    }

//----------------------------------------------------------------------------------------------------------------------
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
    }

//----------------------------------------------------------------------------------------------------------------------
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    

//----------------------------------------------------------------------------------------------------------------------
    @IBAction func stopButtonPressed(sender: InvertedStopButton)
    {
    
    }

//----------------------------------------------------------------------------------------------------------------------
    @IBAction func cancelButtonPressed(sender: InvertedCancelButton)
    {

    }
    
//----------------------------------------------------------------------------------------------------------------------
    @IBAction func resumeButtonPressed(sender: InvertedStartButton)
    {

    }
    
    
// MARK: - Navigation
//----------------------------------------------------------------------------------------------------------------------
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if let segueIdentifier = segue.identifier {
            print(segueIdentifier)
        } else {
            print("unknown Segue ")
        }
    }
//----------------------------------------------------------------------------------------------------------------------
    override func showViewController(vc: UIViewController, sender: AnyObject?) {
        print("STAGE 3")
    }
}

//
//MARK: - ToTimerRunningAnimator
//
private class ToTimerRunningAnimator:NSObject, Animator {
    let transitionDuration = 0.25
    var timerPausedVC:TimerPausedViewController?
    var timerRunningVC:TimerRunningViewController?
    var container:UIView?
    var completionBlock: (() -> Void)?
    
//----------------------------------------------------------------------------------------------------------------------
    func animateTransition(fromVC: UIViewController, toVC: UIViewController, container: UIView, completion: (() -> Void)?)
    {
        //Remember: Container is the actual view of the parent controller.
        //It already contains the fromVC.view.
        //It is the animator's responsibility to remove the fromVC.view and insert the toVC.view
        
        //1. Store the parameters as instance variables
        self.timerPausedVC = fromVC as? TimerPausedViewController
        self.timerRunningVC = toVC as? TimerRunningViewController
        self.container = container
        self.completionBlock = completion
        
        //2. Insert the toVC.view under the fromVC.view so that we can uncover it during the animation
        container.insertSubview(toVC.view, belowSubview: fromVC.view)
        //3. Prepare the shrinking circle layer and set it as fromVC mask layer
    }

//----------------------------------------------------------------------------------------------------------------------
    override func animationDidStop(anim: CAAnimation, finished flag: Bool)
    {
        
    }
}
