//
//  TimerRunningViewController.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 27.10.2015.
//  Copyright © 2015 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class TimerRunningViewController: UIViewController {
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var toolbarFiller: UIView!
    @IBOutlet weak var topContainer: UIView!
    
    private let transitionManager = TransitionManager()
    
    var timer = NSTimer()
    var counter = 0 //number of seconds
    
//----------------------------------------------------------------------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red:1.0, green:0.945, blue: 0.902, alpha:1.0)
        toolbarFiller.backgroundColor = view.backgroundColor
        topContainer.backgroundColor = view.backgroundColor
    }
    
//----------------------------------------------------------------------------------------------------------------------
    override func viewWillAppear(animated: Bool) {
        updateTimeLabel()
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target:self, selector: "countDown",
            userInfo: nil, repeats: true)
    }

//----------------------------------------------------------------------------------------------------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//----------------------------------------------------------------------------------------------------------------------
    @IBAction func pauseButtonPressed(sender: UIButton) {
        timer.invalidate()
    }
    
//----------------------------------------------------------------------------------------------------------------------
    func countDown() {
        counter--
        updateTimeLabel()
        if counter == 0 {
            //initiate the segue programatically
            //stopButtonPressed(stopButton)
        }
    }
    
//----------------------------------------------------------------------------------------------------------------------
    private func updateTimeLabel() {
        var counterCopy = counter
        let hours = counterCopy / 3600
        counterCopy = counterCopy % 3600
        let minutes = counterCopy / 60
        counterCopy = counterCopy % 60
        let seconds = counterCopy
        
        var timeText = "\(hours):"
        if minutes == 0 {
            timeText += "00:"
        } else {
            if minutes < 10 {
                timeText += "0"
            }
            timeText += "\(minutes):"
        }
        if seconds == 0 {
            timeText += "00"
        } else {
            if seconds < 10 {
                timeText += "0"
            }
            timeText += "\(seconds)"
        }
        
        timeLabel.text = timeText
        
    }
    
    //MARK: - Navigation
//----------------------------------------------------------------------------------------------------------------------
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let segueIdentifier = segue.identifier {
            if segueIdentifier == "timerRunningVCToTimerPausedVC" {
                segue.destinationViewController.transitioningDelegate = self.transitionManager
            }
            print(segueIdentifier)
        } else {
            print ("unknown segue")
        }
    }
    
//----------------------------------------------------------------------------------------------------------------------
    @IBAction func unwindToTimerRunningVC (segue: UIStoryboardSegue) {
        if let segueIdentifier = segue.identifier {
            print(segueIdentifier)
        } else {
            print ("unknown segue")
        }
    }

}


//
// MARK - TransitionManager
//
private class TransitionManager: NSObject, UIViewControllerTransitioningDelegate {
    let animator = Animator()
    let dismissAnimator = DismissAnimator()
    
    //----------------------------------------------------------------------------------------------------------------------
    @objc func animationControllerForPresentedController(presented: UIViewController,
        presentingController presenting: UIViewController,
        sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        return animator
    }
    
    //----------------------------------------------------------------------------------------------------------------------
    @objc func animationControllerForDismissedController(dismissed: UIViewController)
        -> UIViewControllerAnimatedTransitioning?
    {
        return dismissAnimator
    }
    
}

//
// MARK - Animator
//

private class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    var context:UIViewControllerContextTransitioning?
    var container: UIView?
    var timerRunningVC: TimerRunningViewController?
    var timerPausedVC: TimerPausedViewController?
    var animationCounter = 0
    var animationLayers = [CALayer]()
    
//----------------------------------------------------------------------------------------------------------------------
    @objc func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval
    {
        return 1.0
    }
    
//----------------------------------------------------------------------------------------------------------------------
    @objc func animateTransition(transitionContext: UIViewControllerContextTransitioning)
    {
        animationCounter = 0
        self.context = transitionContext
        self.container = transitionContext.containerView()
        self.timerRunningVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
            as? TimerRunningViewController
        self.timerPausedVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
            as? TimerPausedViewController
        
        //temporary code:
        container!.addSubview(self.timerPausedVC!.view)
        timerRunningVC!.view.removeFromSuperview()
        context!.completeTransition(true)

    }
    
//----------------------------------------------------------------------------------------------------------------------
    override func animationDidStop(anim: CAAnimation, finished flag: Bool)
    {

    }
}

//
// MARK - DismissAnimator
//

private class DismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var context: UIViewControllerContextTransitioning?
    var container: UIView?
    var timeSliderVC: TimeSliderViewController?
    var timerRunningVC: TimerRunningViewController?
    
//----------------------------------------------------------------------------------------------------------------------
    @objc func transitionDuration(transitionContext: UIViewControllerContextTransitioning?)
        -> NSTimeInterval
    {
        return 0.5
    }
    
//----------------------------------------------------------------------------------------------------------------------
    @objc func animateTransition(transitionContext: UIViewControllerContextTransitioning)
    {
        
    }
    
//----------------------------------------------------------------------------------------------------------------------
    override func animationDidStop(anim: CAAnimation, finished flag: Bool)
    {
        
    }
    
}
