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
    var numberOfSecondsTheTimerWasSetTo = 0

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
                timerRunningVC.numberOfSecondsTheTimerWasSetTo = numberOfSecondsTheTimerWasSetTo
                return
            }
            if segueIdentifier == "TimerPausedToTimeSlider" {
                let timeSliderVC = segue.destinationViewController as! TimeSliderViewController
                timeSliderVC.projectName = projectName
                return
            }
            if segueIdentifier == "TimerPausedToTimerDone" {
                let timerDoneVC = segue.destinationViewController as! TimerDoneViewController
                timerDoneVC.projectName = projectName
                timerDoneVC.numberOfSecondsTheTimerWasSetTo = numberOfSecondsTheTimerWasSetTo
                timerDoneVC.numberOfSecondsToCountDown = numberOfSecondsToCountDown
                return
            }
        }
    }

    override func showViewController(vc: UIViewController, sender: AnyObject?) {
        let containerVC = parentViewController as! ContainerViewController
        let button = sender as! AbstractOvalButton
        if button == self.resumeButton {
            containerVC.switchViewControllers(self, toVC: vc, animator:
                ShrinkingCircleAnimator(circleCenter: resumeButton.center, parentView: resumeButton.superview!))
        }
        if button == self.cancelButton {
            containerVC.switchViewControllers(self, toVC: vc, animator: FadeInAnimator())
        }
        if button == self.stopButton {
            containerVC.switchViewControllers(self, toVC: vc, animator: FadeInAnimator())
        }
    }
}




