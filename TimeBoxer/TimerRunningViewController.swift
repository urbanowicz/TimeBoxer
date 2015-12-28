//
//  TimerRunningViewController.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 27.10.2015.
//  Copyright © 2015 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class TimerRunningViewController: UIViewController {
    @IBOutlet weak var pauseButton: PauseButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var toolbarFiller: UIView!
    @IBOutlet weak var topContainer: UIView!
    
    private let transitionManager = TransitionManager(animator: Animator(), dismissAnimator: DismissAnimator())
    
    var timer = NSTimer()
    var counter = 0 //number of seconds
    
//----------------------------------------------------------------------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red:1.0, green:0.945, blue: 0.902, alpha:1.0)
        toolbarFiller.backgroundColor = view.backgroundColor
        topContainer.backgroundColor = view.backgroundColor
        
        pauseButton.frontLayerColor = UIColor(red:1.0, green:0.945, blue: 0.902, alpha:1.0)
        pauseButton.ovalLayerHighlightedColor = pauseButton.ovalLayerColor
        pauseButton.frontLayerHighlightedColor = pauseButton.frontLayerColor
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
            if segueIdentifier == "TimerRunningVCToTimerPausedVC" {
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
            if segueIdentifier == "TimerPausedVCToTimerRunningVC" {
                print("unwind \(segueIdentifier)")
                segue.sourceViewController.transitioningDelegate = self.transitionManager
            }
        }
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
        return 0.3
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
        timerPausedVC!.view.layer.mask = prepareExpandingCircleAnimationLayer()
        container!.addSubview(self.timerPausedVC!.view)


    }
    
//----------------------------------------------------------------------------------------------------------------------
    override func animationDidStop(anim: CAAnimation, finished flag: Bool)
    {
        timerRunningVC!.view.removeFromSuperview()
        context!.completeTransition(true)
    }
//----------------------------------------------------------------------------------------------------------------------
    private func prepareExpandingCircleAnimationLayer() -> CALayer
    {
        let animationLayer = CAShapeLayer()
        //Create the small circle path and the large circle path
        let pauseButton = timerRunningVC!.pauseButton
        let pauseButtonCenter:CGPoint = container!.convertPoint(pauseButton.center, fromView: pauseButton.superview)
        let smallCirclePath = CirclePathWrapper(centerX: pauseButtonCenter.x, centerY: pauseButtonCenter.y,
            radius: pauseButton.radius).path
        let largeCirclePath = createLargeCircleForButton(pauseButton).path
        animationLayer.path = largeCirclePath
        
        //Create the animation
        let animation = CABasicAnimation(keyPath: "path")
        animation.delegate = self
        animation.duration = transitionDuration((context!))
        animation.fromValue = smallCirclePath
        animation.toValue = largeCirclePath
        animationLayer.addAnimation(animation, forKey: "path")
        return animationLayer
    }
//----------------------------------------------------------------------------------------------------------------------
    private func createLargeCircleForButton(button:AbstractOvalButton) -> CirclePathWrapper
    {
        let circleCenter:CGPoint = container!.convertPoint(button.center, fromView: button.superview)
        let xs = circleCenter.x
        let ys = circleCenter.y
        let x0 = container!.frame.origin.x
        let y0 = container!.frame.origin.y
        let  largeRadius = sqrt(pow((xs - x0),2) + pow((ys - y0),2))
        return CirclePathWrapper(centerX: xs, centerY: ys, radius: largeRadius)
    }
}

//
// MARK - DismissAnimator
//

private class DismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var context: UIViewControllerContextTransitioning?
    var container: UIView?
    var timerPausedVC: TimerPausedViewController?
    var timerRunningVC: TimerRunningViewController?
    
//----------------------------------------------------------------------------------------------------------------------
    @objc func transitionDuration(transitionContext: UIViewControllerContextTransitioning?)
        -> NSTimeInterval
    {
        return 0.3
    }
    
//----------------------------------------------------------------------------------------------------------------------
    @objc func animateTransition(transitionContext: UIViewControllerContextTransitioning)
    {
        self.context = transitionContext
        self.container = transitionContext.containerView()
        self.timerPausedVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
            as? TimerPausedViewController
        self.timerRunningVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
            as? TimerRunningViewController
        
        container!.insertSubview(timerRunningVC!.view, belowSubview: timerPausedVC!.view)
        timerPausedVC!.view.layer.mask = prepareShrinkingCircleAnimationLayer()
    }
    
//----------------------------------------------------------------------------------------------------------------------
    override func animationDidStop(anim: CAAnimation, finished flag: Bool)
    {
        timerPausedVC!.view.removeFromSuperview()
        context!.completeTransition(true)
    }
    
//----------------------------------------------------------------------------------------------------------------------
    private func prepareShrinkingCircleAnimationLayer() -> CALayer
    {
        let animationLayer = CAShapeLayer()
        let resumeButton = timerPausedVC!.resumeButton
        let resumeButtonCenter = container!.convertPoint(resumeButton.center, fromView: resumeButton.superview)
        let smallCirclePath = CirclePathWrapper(centerX: resumeButtonCenter.x, centerY: resumeButtonCenter.y,
            radius: 0.0).path
        let largeCirclePath = createLargeCircleForButton(resumeButton).path
        animationLayer.path = smallCirclePath
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.delegate = self
        animation.duration = transitionDuration((context!))
        animation.fromValue = largeCirclePath
        animation.toValue = smallCirclePath
        animationLayer.addAnimation(animation, forKey: "path")
        return animationLayer
    }

//----------------------------------------------------------------------------------------------------------------------
    private func createLargeCircleForButton(button:AbstractOvalButton) -> CirclePathWrapper
    {
        let circleCenter:CGPoint = container!.convertPoint(button.center, fromView: button.superview)
        let xs = circleCenter.x
        let ys = circleCenter.y
        let x0 = container!.frame.origin.x
        let y0 = container!.frame.origin.y
        let  largeRadius = sqrt(pow((xs - x0),2) + pow((ys - y0),2))
        return CirclePathWrapper(centerX: xs, centerY: ys, radius: largeRadius)
    }
}
