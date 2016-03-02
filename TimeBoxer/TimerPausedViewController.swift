//
//  TimerPausedViewController.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 05.11.2015.
//  Copyright © 2015 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class TimerPausedViewController: UIViewController {
    
    @IBOutlet weak var appTitleLabel: UILabel!
    @IBOutlet weak var pausedLabel: UILabel!
    @IBOutlet weak var resumeButton: StartButton!
    @IBOutlet weak var cancelButton: CancelButton!
    @IBOutlet weak var stopButton: StopButton!
    var projectName:String?
    var numberOfSecondsToCountDown = 0
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = Colors.toUIColor(.ALMOST_BLACK)
        setupAppTitleLabel()
        setupResumeButton()
        setupCancelButton()
        setupStopButton()
        setupPausedLabel()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
//MARK: Setup UI elements
    private func setupAppTitleLabel() {
        appTitleLabel.textColor = Colors.toUIColor(.OFF_WHITE)
    }
    private func setupResumeButton() {
        resumeButton.borderColor = Colors.toUIColor(.OFF_WHITE)!
        resumeButton.ovalLayerColor = Colors.toUIColor(.ALMOST_BLACK)!
        resumeButton.frontLayerColor = Colors.toUIColor(.OFF_WHITE)!
        resumeButton.ovalLayerHighlightedColor = Colors.toUIColor(.OFF_WHITE)!
        resumeButton.frontLayerHighlightedColor = Colors.toUIColor(.ALMOST_BLACK)!
        resumeButton.borderWidth = 2.0
    }
    
    private func setupCancelButton() {
        cancelButton.borderColor = Colors.toUIColor(.OFF_WHITE)!
        cancelButton.ovalLayerColor = Colors.toUIColor(.ALMOST_BLACK)!
        cancelButton.frontLayerColor = Colors.toUIColor(.OFF_WHITE)!
        cancelButton.ovalLayerHighlightedColor = Colors.toUIColor(.OFF_WHITE)!
        cancelButton.frontLayerHighlightedColor = Colors.toUIColor(.ALMOST_BLACK)!
        cancelButton.borderWidth = 2.0
    }
    
    private func setupStopButton() {
        stopButton.borderColor = Colors.toUIColor(.OFF_WHITE)!
        stopButton.ovalLayerColor = Colors.toUIColor(.ALMOST_BLACK)!
        stopButton.frontLayerColor = Colors.toUIColor(.OFF_WHITE)!
        stopButton.ovalLayerHighlightedColor = Colors.toUIColor(.OFF_WHITE)!
        stopButton.frontLayerHighlightedColor = Colors.toUIColor(.ALMOST_BLACK)!
        stopButton.borderWidth = 2.0
    }
    
    private func setupPausedLabel() {
        pausedLabel.textColor = Colors.toUIColor(.OFF_WHITE)!
    }
    
//MARK: Actions
    @IBAction func stopButtonPressed(sender: StopButton)
    {
        performSegueWithIdentifier("TimerPausedToTimerDone", sender: sender)
    }


    @IBAction func cancelButtonPressed(sender: CancelButton)
    {
        performSegueWithIdentifier("TimerPausedToTimeSlider", sender: sender)
    }
    

    @IBAction func resumeButtonPressed(sender: StartButton)
    {
        performSegueWithIdentifier("TimerPausedToTimerRunning", sender: sender)
    }
    
    
// MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if let segueIdentifier = segue.identifier {
            if segueIdentifier == "TimerPausedToTimerRunning" {
                let timerRunningVC = segue.destinationViewController as! TimerRunningViewController
                timerRunningVC.numberOfSecondsToCountDown = numberOfSecondsToCountDown
                timerRunningVC.projectName = projectName
                return
            }
            if segueIdentifier == "TimerPausedToTimeSlider" {
                let timeSliderVC = segue.destinationViewController as! TimeSliderViewController
                timeSliderVC.projectName = projectName
                return
            }
            if segueIdentifier == "TimerPausedToTimerDone" {
                
            }
        }
    }

    override func showViewController(vc: UIViewController, sender: AnyObject?) {
        let containerVC = parentViewController as! ContainerViewController
        let button = sender as! AbstractOvalButton
        if button == self.resumeButton {
            containerVC.switchViewControllers(self, toVC: vc, animator: ToTimerRunningAnimator())
        }
        if button == self.cancelButton {
            containerVC.switchViewControllers(self, toVC: vc, animator: FadeInAnimator())
        }
        if button == self.stopButton {
            containerVC.switchViewControllers(self, toVC: vc, animator: FadeInAnimator())
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


    override func animationDidStop(anim: CAAnimation, finished flag: Bool)
    {
        //Done with the animation. Do the cleanup.
        timerPausedVC!.view.removeFromSuperview()
        timerPausedVC!.view.layer.mask = nil
        if let executeCompletionBlock = completionBlock {
            executeCompletionBlock()
        }
    }


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
//MARK: FadeInAnimator
//

private class FadeInAnimator:NSObject, Animator {
    let transitionDuration = 0.3
    
    func animateTransition(fromVC: UIViewController, toVC: UIViewController, container: UIView, completion: (() -> Void)?) {
        //Remember: Container is the actual view of the parent controller.
        //It already contains the fromVC.view.
        //It is the animator's responsibility to remove the fromVC.view and insert the toVC.view
        
        
        //Prepare the toVC.view to be faded in
        toVC.view.alpha = 0.0
        container.addSubview(toVC.view)
        
        UIView.animateWithDuration(transitionDuration,
            animations: { toVC.view.alpha = 1.0 } ,
            completion: {
                finished in
                fromVC.view.removeFromSuperview()
                if let executeCompletionBlock = completion {
                    executeCompletionBlock()
                }
            }
        )
    }
}

