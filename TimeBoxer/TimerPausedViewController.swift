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
    @IBOutlet weak var resumeButton: StartButton!
    @IBOutlet weak var cancelButton: CancelButton!
    @IBOutlet weak var stopButton: StopButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var projectNameLabel: UILabel!
    
    private let timeLabelTextFormatter = TimeLabelTextFormatter()
    var numberOfSecondsToCountDown = 0
    var numberOfSecondsTheTimerWasSetTo = 0
    var project: Project?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = Colors.almostBlack()
        setupAppTitleLabel()
        setupResumeButton()
        setupCancelButton()
        setupStopButton()
        setupProjectNameLabel()
        setupTimeLabel()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
//MARK: Setup UI elements
    private func setupAppTitleLabel() {
        appTitleLabel.textColor = Colors.silver().withAlpha(0.15)
    }
    private func setupResumeButton() {
        resumeButton.borderColor = Colors.silver()
        resumeButton.ovalLayerColor = Colors.almostBlack()
        resumeButton.frontLayerColor = Colors.silver()
        resumeButton.ovalLayerHighlightedColor = Colors.silver()
        resumeButton.frontLayerHighlightedColor = Colors.almostBlack()
        resumeButton.borderWidth = 2.0
    }
    
    private func setupCancelButton() {
        cancelButton.borderColor = Colors.silver()
        cancelButton.ovalLayerColor = Colors.almostBlack()
        cancelButton.frontLayerColor = Colors.silver()
        cancelButton.ovalLayerHighlightedColor = Colors.silver()
        cancelButton.frontLayerHighlightedColor = Colors.almostBlack()
        cancelButton.borderWidth = 2.0
    }
    
    private func setupStopButton() {
        stopButton.borderColor = Colors.golden()
        stopButton.ovalLayerColor = Colors.almostBlack()
        stopButton.frontLayerColor = Colors.golden()
        stopButton.ovalLayerHighlightedColor = Colors.golden()
        stopButton.frontLayerHighlightedColor = Colors.almostBlack()
        stopButton.borderWidth = 2.0
    }
    
    private func setupTimeLabel() {
        timeLabel.textColor = Colors.silver().withAlpha(0.15)
        timeLabel.text = timeLabelTextFormatter.formatWithNumberOfSecondsToCountDown(numberOfSecondsToCountDown)
    }
    
    private func setupProjectNameLabel() {
        projectNameLabel.textColor = Colors.silver().withAlpha(0.15)
        projectNameLabel.text = project!.name
        projectNameLabel.numberOfLines = 4
        projectNameLabel.adjustsFontSizeToFitWidth = true
        projectNameLabel.sizeToFit()
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
                timerRunningVC.projectName = project!.name
                timerRunningVC.project = project
                timerRunningVC.numberOfSecondsTheTimerWasSetTo = numberOfSecondsTheTimerWasSetTo
                return
            }
            if segueIdentifier == "TimerPausedToTimeSlider" {
                let timeSliderVC = segue.destinationViewController as! TimeSliderViewController
                timeSliderVC.projectName = project!.name
                timeSliderVC.project = project
                return
            }
            if segueIdentifier == "TimerPausedToTimerDone" {
                let timerDoneVC = segue.destinationViewController as! TimerDoneViewController
                timerDoneVC.projectName = project!.name
                timerDoneVC.project = project
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




