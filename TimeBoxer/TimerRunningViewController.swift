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
    @IBOutlet weak var appTitleLabel: UILabel!
    @IBOutlet weak var projectNameLabel: UILabel!
    
    var projectName:String?
    
    private let toTimerPausedAnimator = ToTimerPausedAnimator()
    var timer = NSTimer()
    var numberOfSecondsToCountDown = 0 //number of seconds
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = Colors.toUIColor(.OFF_WHITE)!
        setupAppTitleLabel()
        setupProjectNameLabel()
        setupTimeLabel()
        setupPauseButton()
    }
    

    override func viewWillAppear(animated: Bool) {
        updateTimeLabel()
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target:self, selector: "countDown",
            userInfo: nil, repeats: true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//MARK: Setup UI elements
    private func setupAppTitleLabel() {
        appTitleLabel.textColor = Colors.toUIColor(.ALMOST_BLACK)
        appTitleLabel.sizeToFit()
    }
    
    private func setupProjectNameLabel() {
        projectNameLabel.textColor = Colors.toUIColor(.ALMOST_BLACK)
        projectNameLabel.text = projectName!
        projectNameLabel.numberOfLines = 4
        projectNameLabel.adjustsFontSizeToFitWidth = true
        projectNameLabel.sizeToFit()
    }
    
    private func setupTimeLabel() {
        timeLabel.textColor = Colors.toUIColor(.ALMOST_BLACK)
    }
    
    private func setupPauseButton() {
        pauseButton.borderColor = Colors.toUIColor(.ALMOST_BLACK)!
        pauseButton.ovalLayerColor = Colors.toUIColor(.OFF_WHITE)!
        pauseButton.frontLayerColor = Colors.toUIColor(.ALMOST_BLACK)!
        pauseButton.ovalLayerHighlightedColor = Colors.toUIColor(.ALMOST_BLACK)!
        pauseButton.frontLayerHighlightedColor = Colors.toUIColor(.OFF_WHITE)!
        pauseButton.borderWidth = 2.0
    }
    
//MARK: Actions
    @IBAction func pauseButtonPressed(sender: UIButton) {
        timer.invalidate()
        performSegueWithIdentifier("TimerRunningToTimerPaused", sender: self)
    }

    func countDown() {
        numberOfSecondsToCountDown--
        updateTimeLabel()
        if numberOfSecondsToCountDown == 0 {
            //initiate the segue programatically
            //stopButtonPressed(stopButton)
        }
    }
    
    private func updateTimeLabel() {
        var counterCopy = numberOfSecondsToCountDown
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let segueIdentifier = segue.identifier {
            if segueIdentifier == "TimerRunningToTimerPaused" {
                let timerPausedVC = segue.destinationViewController as! TimerPausedViewController
                timerPausedVC.numberOfSecondsToCountDown = numberOfSecondsToCountDown
                timerPausedVC.projectName = projectName
                return
            }
        }
    }

    override func showViewController(vc: UIViewController, sender: AnyObject?) {
        let containerVC = parentViewController as! ContainerViewController
        containerVC.switchViewControllers(self, toVC: vc, animator: toTimerPausedAnimator)
    }

}


//
// MARK: - ToTimerPausedAnimator
//
private class ToTimerPausedAnimator: NSObject, Animator {
    let transitionDuration = 0.25
    var timerRunningVC:TimerRunningViewController?
    var timerPausedVC:TimerPausedViewController?
    var container:UIView?
    var completionBlock:(()->Void)?

//----------------------------------------------------------------------------------------------------------------------
    func animateTransition(fromVC: UIViewController, toVC: UIViewController, container: UIView, completion: (() -> Void)?)
    {
        //Remember: container is the view of the parent controller. It already contains the
        //fromVC.view
        //It is the animator's responsibility to remove the fromVC.view from the container and
        //add the toVC.view to the container
        
        //1. Store the function parameters as instance variables
        self.timerRunningVC = fromVC as? TimerRunningViewController
        self.timerPausedVC = toVC as? TimerPausedViewController
        self.container = container
        self.completionBlock = completion
        
        //2. Crete the expanding circle animation layer and set it as a mask layer of the toVC.view
        let expandingCircleAnimationLayer = prepareExpandingCircleAnimationLayer()
        toVC.view.layer.mask = expandingCircleAnimationLayer
        container.addSubview(toVC.view)
    }

//----------------------------------------------------------------------------------------------------------------------
    override func animationDidStop(anim: CAAnimation, finished flag: Bool)
    {
        //Done with the animation, do the final cleanup
        timerPausedVC!.view.layer.mask = nil
        timerRunningVC!.view.removeFromSuperview()
        if let executeCompletionBlock = completionBlock {
            executeCompletionBlock()
        }
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
        animation.duration = transitionDuration
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
// MARK: - DismissAnimator
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
