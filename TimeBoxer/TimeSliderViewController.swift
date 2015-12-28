//
//  RangeSliderViewController.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 22.10.2015.
//  Copyright © 2015 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class TimeSliderViewController: UIViewController {
    
    @IBOutlet weak var timeSlider: SimpleTimeSlider!
    @IBOutlet weak var startButton: StartButton!
    
    let startButtonBackgroundColor = UIColor(red:1.0, green:0.945, blue: 0.902, alpha:1.0)
    let startButtonFrontLayerColor = UIColor(white:0.15, alpha:1.0)
    
    private let transitionManager = TransitionManager(animator: Animator(), dismissAnimator: DismissAnimator())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.ovalLayerColor = startButtonBackgroundColor
        startButton.frontLayerColor = startButtonFrontLayerColor
        startButton.frontLayerHighlightedColor = startButtonFrontLayerColor
        startButton.ovalLayerHighlightedColor = startButtonBackgroundColor
        startButton.borderColor = startButtonFrontLayerColor
        startButton.borderWidth = 1.0
        // Do any additional setup after loading the view.

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        timeSlider.frameIsReady()
    }
    
    override func viewDidLayoutSubviews() {
        timeSlider.frameIsReady()
    }

    @IBAction func timeSliderValueChanged(sender: SimpleTimeSlider) {
        
    }
    
    //MARK - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let segueIdentifier = segue.identifier {
            print(segueIdentifier)
        }
        
        let timerRunningViewController = segue.destinationViewController as! TimerRunningViewController
        timerRunningViewController.counter = timeSlider.value * 60
        timerRunningViewController.transitioningDelegate = transitionManager
    }
    
    @IBAction func unwindToTimeSliderVC(sender: UIStoryboardSegue) {
        if let segueIdentifier = sender.identifier {
            print("unwind \(segueIdentifier)")
            if segueIdentifier == "TimerPausedVCToTimeSliderVC" {
                sender.sourceViewController.transitioningDelegate = nil
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
    var timeSliderVC: TimeSliderViewController?
    var timerRunningVC: TimerRunningViewController?
    var animationCounter = 0
    var animationLayers = [CALayer]()
    
//----------------------------------------------------------------------------------------------------------------------
    @objc func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval
    {
        return 0.5
    }
    
//----------------------------------------------------------------------------------------------------------------------
    @objc func animateTransition(transitionContext: UIViewControllerContextTransitioning)
    {
        animationCounter = 0
        self.context = transitionContext
        self.container = transitionContext.containerView()
        self.timeSliderVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
            as? TimeSliderViewController
        self.timerRunningVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
            as? TimerRunningViewController
        let circleLayer = prepareExpandingCircleAnimationLayer()
        animationLayers.append(circleLayer)
        container!.layer.addSublayer(circleLayer)
    }
    
//----------------------------------------------------------------------------------------------------------------------
    override func animationDidStop(anim: CAAnimation, finished flag: Bool)
    {
        if animationCounter == 0 {
            animationCounter++
            prepareFadeInAnimationLayer()
            container!.addSubview(timerRunningVC!.view)
        } else {
            timeSliderVC!.view.removeFromSuperview()
            for animationLayer in animationLayers {
                animationLayer.removeFromSuperlayer()
            }
            context!.completeTransition(true)
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
        animation.duration = transitionDuration(context!) / 2.0
        animation.fromValue = smallCircle.path
        animation.toValue = largeCircle.path
        shapeLayer.addAnimation(animation, forKey: "path")
        return shapeLayer
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

//----------------------------------------------------------------------------------------------------------------------
    private func prepareFadeInAnimationLayer() -> CALayer
    {
        let timerRunningLayer = timerRunningVC!.view.layer
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.delegate = self
        animation.duration = transitionDuration(context!) / 2.0
        animation.fromValue = 0.0
        animation.toValue = 1.0
        timerRunningLayer.addAnimation(animation, forKey: "opacity")
        return timerRunningLayer
    }
    
}

//
// MARK -DismissAnimator
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


