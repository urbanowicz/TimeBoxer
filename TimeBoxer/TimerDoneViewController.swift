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
    var project:Project?
    
    @IBOutlet weak var appTitleLabel: UILabel!
    @IBOutlet weak var completedLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var ofLabel: UILabel!
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var okButton: OKButton!
    @IBOutlet weak var zeroMinutesLabel: UILabel!
    
    private let minutesToStringConverter = MinutesToStringConverter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.golden()
        
        hideAllLabels()
        
        if numberOfSecondsTheTimerWasSetTo - numberOfSecondsToCountDown < 60 {
            setupZeroMinutesLabel()
        } else {
        
            setupCompletedLabel()
            setupTimeLabel()
            setupOfLabel()
            setupProjectNameLabel()
        }
        setupAppTitleLabel()
        setupOKButton()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

//MARK: Setup UI elements
    private func hideAllLabels() {
        zeroMinutesLabel.hidden = true
        completedLabel.hidden = true
        timeLabel.hidden = true
        ofLabel.hidden = true
        projectNameLabel.hidden = true
    }
    private func setupZeroMinutesLabel() {
        zeroMinutesLabel.hidden = false
        zeroMinutesLabel.numberOfLines = 2
        zeroMinutesLabel.adjustsFontSizeToFitWidth = true
        zeroMinutesLabel.textColor = Colors.almostBlack()
    }
    private func setupAppTitleLabel() {
        appTitleLabel.textColor = Colors.almostBlack()
        appTitleLabel.sizeToFit()
    }
    private func setupCompletedLabel() {
        completedLabel.hidden = false
        completedLabel.textColor = Colors.lightGray()
    }
    private func setupTimeLabel() {
        let numberOfCompletedMinutes = Int((numberOfSecondsTheTimerWasSetTo - numberOfSecondsToCountDown) / 60)
        timeLabel.hidden = false
        timeLabel.text = minutesToStringConverter.convert(numberOfCompletedMinutes)
        timeLabel.textColor = Colors.almostBlack()
    }
    private func setupOfLabel() {
        ofLabel.hidden = false
        ofLabel.textColor = Colors.lightGray()
    }
    private func setupProjectNameLabel() {
        projectNameLabel.hidden = false
        projectNameLabel.textColor = Colors.almostBlack()
        projectNameLabel.text = projectName
        projectNameLabel.numberOfLines = 4
        projectNameLabel.adjustsFontSizeToFitWidth = true
        projectNameLabel.sizeToFit()
    }
    
    private func setupOKButton() {
        okButton.borderColor = Colors.almostBlack()
        okButton.ovalLayerColor = Colors.golden()
        okButton.frontLayerStrokeColor = Colors.almostBlack()
        okButton.ovalLayerHighlightedColor = Colors.golden()
        okButton.frontLayerHighlighteStrokeColor = Colors.almostBlack()
        okButton.borderWidth = 2.0
    }
    
    @IBAction func okButtonPressed(sender: OKButton) {
        recordWorkDone()
        performSegueWithIdentifier("TimerDoneToTimeSlider", sender: sender)
    }
    
    private func recordWorkDone() {
        let numberOfCompletedMinutes = Int((numberOfSecondsTheTimerWasSetTo - numberOfSecondsToCountDown) / 60)
        if numberOfCompletedMinutes >= 1 {
            project?.recordWork(numberOfCompletedMinutes * 60)
        }
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
        containerVC.switchViewControllers(self, toVC: vc, animator:
            ShrinkingCircleAnimator(circleCenter: okButton.center, parentView: okButton.superview!))
    }
}
