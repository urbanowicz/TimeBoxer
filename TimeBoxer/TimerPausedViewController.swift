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
    @IBOutlet weak var resumeButton: StartButton!
    @IBOutlet weak var cancelButton: CancelButton!
    @IBOutlet weak var stopButton: StopButton!
    private let toTimerRunningAnimator = ToTimerRunningAnimator()
    private let toTimeSliderAnimator = ToTimeSliderAnimator2()
    var counter = 0
//----------------------------------------------------------------------------------------------------------------------

    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = Colors.toUIColor(.ALMOST_BLACK)

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
            if segueIdentifier == "TimerPausedToTimerRunning" {
                let timerRunningVC = segue.destinationViewController as! TimerRunningViewController
                timerRunningVC.counter = counter
            }
        } else {
            print("unknown Segue ")
        }
    }
//----------------------------------------------------------------------------------------------------------------------
    override func showViewController(vc: UIViewController, sender: AnyObject?) {
        let containerVC = parentViewController as! ContainerViewController
        let button = sender as! AbstractOvalButton
        if button == self.resumeButton {
            containerVC.switchViewControllers(self, toVC: vc, animator: toTimerRunningAnimator)
        }
        if button == self.cancelButton {
            containerVC.switchViewControllers(self, toVC: vc, animator: toTimeSliderAnimator)
        }
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
        let shrinkingCircleLayer = prepareShrinkingCircleAnimationLayer()
        fromVC.view.layer.mask = shrinkingCircleLayer
    }

//----------------------------------------------------------------------------------------------------------------------
    override func animationDidStop(anim: CAAnimation, finished flag: Bool)
    {
        //Done with the animation. Do the cleanup.
        timerPausedVC!.view.removeFromSuperview()
        timerPausedVC!.view.layer.mask = nil
        if let executeCompletionBlock = completionBlock {
            executeCompletionBlock()
        }
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
        animation.duration = transitionDuration
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

//
//MARK: - ToTimeSliderAnimator
//
private class ToTimeSliderAnimator:NSObject, Animator {
    let transitionDuration = 0.25
    var timerPausedVC:TimerPausedViewController?
    var timeSliderVC:TimeSliderViewController?
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
        self.timeSliderVC = toVC as? TimeSliderViewController
        self.container = container
        self.completionBlock = completion
        
        //2. Insert the toVC.view underneath the fromVC.view so that it can be uncovered during the animation.
        container.insertSubview(toVC.view, belowSubview: fromVC.view)
        
        //3. Prepare the shrinking circle layer and set it as the fromVC.view's mask
        let shrkinkingCircleLayer = prepareShrinkingCircleAnimationLayer()
        fromVC.view.layer.mask = shrkinkingCircleLayer
        
    }

//----------------------------------------------------------------------------------------------------------------------
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        timerPausedVC!.view.removeFromSuperview()
        timerPausedVC!.view.layer.mask = nil
        if let executeCompletionBlock = completionBlock {
            executeCompletionBlock()
        }
    }

//----------------------------------------------------------------------------------------------------------------------
    private func prepareShrinkingCircleAnimationLayer() -> CALayer
    {
        let animationLayer = CAShapeLayer()
        let cancelButton = timerPausedVC!.cancelButton
        let cancelButtonCenter = container!.convertPoint(cancelButton.center, fromView: cancelButton.superview)
        let smallCirclePath = CirclePathWrapper(centerX: cancelButtonCenter.x, centerY: cancelButtonCenter.y,
            radius: 0.0).path
        let largeCirclePath = createLargeCircleForButton(cancelButton).path
        animationLayer.path = smallCirclePath
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.delegate = self
        animation.duration = transitionDuration
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

//
//MARK: - ToTimeSliderAnimator2
//
private class ToTimeSliderAnimator2:NSObject, Animator {
    let transitionDuration = 0.3
    var timerPausedVC:TimerPausedViewController?
    var timeSliderVC:TimeSliderViewController?
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
        self.timeSliderVC = toVC as? TimeSliderViewController
        self.container = container
        self.completionBlock = completion
        
        //2. Setup a white background 
        let whiteLayer = CALayer()
        whiteLayer.backgroundColor = UIColor.whiteColor().CGColor
        whiteLayer.opacity = 0.0
        //whiteLayer.frame = fromVC.view.layer.frame
        fromVC.view.layer.addSublayer(whiteLayer)
        
        //3. Prepare the toVC.view to be faded in
        toVC.view.alpha = 0.0
        container.addSubview(toVC.view)
        
        UIView.animateKeyframesWithDuration(transitionDuration, delay: 0.0, options: UIViewKeyframeAnimationOptions.CalculationModeLinear,
            animations: {
                UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.25,
                    animations: {
                        whiteLayer.opacity = 1.0
                    })
                UIView.addKeyframeWithRelativeStartTime(0.25, relativeDuration: 0.75,
                    animations : {
                        toVC.view.alpha = 1.0
                    })
            },
            completion: {
                finished in
                self.timerPausedVC!.view.removeFromSuperview()
                whiteLayer.removeFromSuperlayer()
                if let executeCompletionBlock = self.completionBlock {
                    executeCompletionBlock()
                }
        })
    }
}
