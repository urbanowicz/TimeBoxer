//
//  RangeSliderViewController.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 22.10.2015.
//  Copyright © 2015 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class TimeSliderViewController: UIViewController {
    
    @IBOutlet weak var timeSlider: BigSlider!
    @IBOutlet weak var startButton: StartButton!
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var project:Project?
    
    private let sliderToMinutesConverter = SliderOutputToValueConverter(maxValue: 120, resolution: 5)
    private let minutesToTextConverter = MinutesToStringConverter()
    private let toTimerRunningVCAnimator = ToTimerRunningAnimator()

//---------------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.almostBlack()
        setupStartButton()
        setupTimeLabel()
        setupTimeSlider()
    }
    
    func prepareViewForUse(withProject project:Project) {
        self.project = project
        setupProjectNameLabel()
        timeSlider.refresh()
    }
//---------------------------------------------------------------------------------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//MARK: Setup UI elements
    private func setupStartButton() {
        startButton.borderWidth = 2.0
        startButton.borderColor = Colors.slider()
        startButton.roundLayerColor = Colors.almostBlack()
        startButton.frontLayerColor = Colors.slider()
    }
    
    private func setupProjectNameLabel() {
        projectNameLabel.textColor = Colors.silver()
        projectNameLabel.text = project?.name
        projectNameLabel.numberOfLines = 4
        projectNameLabel.adjustsFontSizeToFitWidth = true
        projectNameLabel.sizeToFit()
    }
    
    private func setupTimeLabel() {
        timeLabel.backgroundColor = Colors.almostBlack()
        timeLabel.textColor = Colors.silver()
        timeLabel.text = "5 minutes"
        timeLabel.sizeToFit()
    }
    
    private func setupTimeSlider() {
        timeSlider.fillColor = Colors.slider()
        timeSlider.addTarget(self, action: #selector(TimeSliderViewController.timeSliderValueChanged), forControlEvents: UIControlEvents.ValueChanged)
    }
    
//MARK: Actions
    @IBAction func timeSliderValueChanged() {
        
        func updateTimeLabelText(text:String) {
            if text != timeLabel.text {
                let animation: CATransition = CATransition()
                animation.duration = 0.1
                animation.type = kCATransitionFade
                animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                timeLabel.layer.addAnimation(animation, forKey: "changeTextTransition")
                timeLabel.text = text
            }
        }
        
        let numberOfMinutes = sliderToMinutesConverter.convert(timeSlider.value)
        let text = minutesToTextConverter.convert(numberOfMinutes)
        updateTimeLabelText(text)
        timeLabel.sizeToFit()
    }
    
    
    
    @IBAction func startButtonPressed(sender: StartButton) {
        performSegueWithIdentifier("TimeSliderToTimerRunning", sender: self)
    }

    
//MARK: - Navigation
//----------------------------------------------------------------------------------------------------------------------
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let segueIdentifier = segue.identifier {
            if segueIdentifier == "TimeSliderToTimerRunning" {
                let timerRunningViewController = segue.destinationViewController as! TimerRunningViewController
                timerRunningViewController.numberOfSecondsToCountDown =
                    sliderToMinutesConverter.convert(timeSlider.value) * 60
                timerRunningViewController.numberOfSecondsTheTimerWasSetTo = timerRunningViewController.numberOfSecondsToCountDown
                timerRunningViewController.project = project
                timerRunningViewController.startTime = NSDate()
            }
        }
    
    }

//----------------------------------------------------------------------------------------------------------------------
    override func showViewController(vc: UIViewController, sender: AnyObject?) {
        let containerVC = parentViewController as! ImprovedContainerViewController
        containerVC.pushViewController(vc, animator: toTimerRunningVCAnimator)
    }

//MARK: Disable auto rotate
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
}


//
//MARK: - ToTimerRunningAnimator
//

private class ToTimerRunningAnimator:NSObject, Animator, CAAnimationDelegate {
    let transitionDuration = 0.5
    var timeSliderVC:TimeSliderViewController?
    var timerRunningVC:TimerRunningViewController?
    var container:UIView?
    var completionBlock: (() -> Void)?
    var animationCounter = 0
    let totalAnimations = 2
    var animationLayers = [CALayer]()
    
//----------------------------------------------------------------------------------------------------------------------
    func animateTransition(fromVC: UIViewController, toVC: UIViewController, container: UIView, completion: (() -> Void)?)
    {
        //Remember: container is the view of the parent controller. It already contains the fromVC.view
        //It is the animator's responsibility to remove the fromVC.view from the container 
        //and add the toVC.view to the container.
        
        
        //1. Store the function parameters as instance variables
        self.timeSliderVC = fromVC as? TimeSliderViewController
        self.timerRunningVC = toVC as? TimerRunningViewController
        self.container = container
        self.completionBlock = completion
        
        //2. Create the expanding circle animation. The rest of the animation is setup from the animationDidStop method
        let expandingCircleAnimationLayer = prepareExpandingCircleAnimationLayer()
        self.animationLayers.append(expandingCircleAnimationLayer)
        self.timeSliderVC!.view.layer.addSublayer(expandingCircleAnimationLayer)
        
    }
//----------------------------------------------------------------------------------------------------------------------
    @objc func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        animationCounter += 1
        if animationCounter == 1 {
            //Done with the expanding circle animation. Prepare the next stage.
            prepareFadeInAnimationLayer()
            container!.addSubview(timerRunningVC!.view)
            return
        }
        if animationCounter == totalAnimations {
            //this was the last animation so do the final cleanup
            animationCounter = 0
            for animationLayer in animationLayers {
                animationLayer.removeFromSuperlayer()
            }
            if let executeCompletionBlock = completionBlock {
                executeCompletionBlock()
            }
        }
    }
    
//----------------------------------------------------------------------------------------------------------------------
    private func prepareExpandingCircleAnimationLayer() -> CALayer
    {
        let startButton = timeSliderVC!.startButton
        let circleCenter:CGPoint = container!.convertPoint(startButton.center, fromView: startButton.superview)
        let smallCircle = CirclePathWrapper(centerX: circleCenter.x, centerY: circleCenter.y, radius: startButton.radius)
        let largeCircle = createLargeCircleForButton(startButton)
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = timerRunningVC!.view.backgroundColor!.CGColor
        shapeLayer.lineWidth = 0.0
        shapeLayer.path = largeCircle.path
        let animation = CABasicAnimation(keyPath: "path")
        animation.delegate = self
        animation.duration = transitionDuration / 2.0
        animation.fromValue = smallCircle.path
        animation.toValue = largeCircle.path
        shapeLayer.addAnimation(animation, forKey: "path")
        return shapeLayer
    }

//----------------------------------------------------------------------------------------------------------------------
    private func createLargeCircleForButton(button:AbstractRoundButton) -> CirclePathWrapper
    {
        let circleCenter:CGPoint = container!.convertPoint(button.center, fromView: button.superview)
        let xs = circleCenter.x
        let ys = circleCenter.y
        let x0 = container!.frame.origin.x
        let y0 = container!.frame.origin.y
        let  largeRadius = sqrt(pow((xs - x0),2) + pow((ys - y0),2))
        return CirclePathWrapper(centerX: xs, centerY: ys, radius: largeRadius)
    }

//----------------------------------------------------------------------------------------------------------------------
    private func prepareFadeInAnimationLayer() -> CALayer
    {
        let timerRunningLayer = timerRunningVC!.view.layer
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.delegate = self
        animation.duration = transitionDuration / 2.0
        animation.fromValue = 0.0
        animation.toValue = 1.0
        timerRunningLayer.addAnimation(animation, forKey: "opacity")
        return timerRunningLayer
    }
    
}
