//
//  TimerDoneViewController.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 02/03/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class TimerDoneViewController: UIViewController {
    
    var projectName:String?
    var numberOfSecondsToCountDown = 0
    var numberOfSecondsTheTimerWasSetTo = 0
    
    @IBOutlet weak var appTitleLabel: UILabel!
    @IBOutlet weak var completedLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var ofLabel: UILabel!
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var okButton: OKButton!
    
    private let minutesToStringConverter = MinutesToStringConverter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.seafoam()
        setupAppTitleLabel()
        setupCompletedLabel()
        setupTimeLabel()
        setupOfLabel()
        setupOKButton()
        setupProjectNameLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

//MARK: Setup UI elements
    private func setupAppTitleLabel() {
        appTitleLabel.textColor = Colors.almostBlack()
        appTitleLabel.sizeToFit()
    }
    private func setupCompletedLabel() {
        completedLabel.textColor = Colors.lightGray()
    }
    private func setupTimeLabel() {
        let numberOfCompletedMinutes = Int((numberOfSecondsTheTimerWasSetTo - numberOfSecondsToCountDown) / 60)
        timeLabel.text = minutesToStringConverter.convert(numberOfCompletedMinutes)
        timeLabel.textColor = Colors.almostBlack()
    }
    private func setupOfLabel() {
        ofLabel.textColor = Colors.lightGray()
    }
    private func setupProjectNameLabel() {
        projectNameLabel.textColor = Colors.almostBlack()
        projectNameLabel.text = projectName
        projectNameLabel.numberOfLines = 4
        projectNameLabel.adjustsFontSizeToFitWidth = true
        projectNameLabel.sizeToFit()
    }
    
    private func setupOKButton() {
        okButton.borderColor = Colors.almostBlack()
        okButton.ovalLayerColor = Colors.seafoam()
        okButton.frontLayerStrokeColor = Colors.almostBlack()
        okButton.ovalLayerHighlightedColor = Colors.seafoam()
        okButton.frontLayerHighlighteStrokeColor = Colors.almostBlack()
        okButton.borderWidth = 2.0
    }
    
    @IBAction func okButtonPressed(sender: OKButton) {
        performSegueWithIdentifier("TimerDoneToTimeSlider", sender: sender)
    }
    
    //MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let segueIdentifier = segue.identifier {
            if segueIdentifier == "TimerDoneToTimeSlider" {
                let timeSliderVC = segue.destinationViewController as! TimeSliderViewController
                timeSliderVC.projectName = projectName
                return
            }
        }
    }
    
    override func showViewController(vc: UIViewController, sender: AnyObject?) {
        let containerVC = parentViewController as! ContainerViewController
        containerVC.switchViewControllers(self, toVC: vc, animator: ToTimeSliderAnimator())
    }
}

//
//MARK: - ToTimeSliderAnimator
//
private class ToTimeSliderAnimator:NSObject, Animator {
    let transitionDuration = 0.25
    var timerDoneVC:TimerDoneViewController?
    var timeSliderVC:TimeSliderViewController?
    var container:UIView?
    var completionBlock: (() -> Void)?
    
    
    func animateTransition(fromVC: UIViewController, toVC: UIViewController, container: UIView, completion: (() -> Void)?)
    {
        //Remember: Container is the actual view of the parent controller.
        //It already contains the fromVC.view.
        //It is the animator's responsibility to remove the fromVC.view and insert the toVC.view
        
        //1. Store the parameters as instance variables
        self.timerDoneVC = fromVC as? TimerDoneViewController
        self.timeSliderVC = toVC as? TimeSliderViewController
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
        timerDoneVC!.view.removeFromSuperview()
        timerDoneVC!.view.layer.mask = nil
        if let executeCompletionBlock = completionBlock {
            executeCompletionBlock()
        }
    }
    
    
    private func prepareShrinkingCircleAnimationLayer() -> CALayer
    {
        let animationLayer = CAShapeLayer()
        let okButton = timerDoneVC!.okButton
        let okButtonCenter = container!.convertPoint(okButton.center, fromView: okButton.superview)
        let smallCirclePath = CirclePathWrapper(centerX: okButtonCenter.x, centerY: okButtonCenter.y,
            radius: 0.0).path
        let largeCirclePath = createLargeCircleForButton(okButton).path
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
