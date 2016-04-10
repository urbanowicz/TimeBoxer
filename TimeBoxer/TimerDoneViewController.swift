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
    
    private var numberOfCompletedSeconds = 0
    private let workTimeFormatter = WorkTimeFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.golden()
        numberOfCompletedSeconds = numberOfSecondsTheTimerWasSetTo - numberOfSecondsToCountDown
        setupCompletedLabel()
        setupTimeLabel()
        setupOfLabel()
        setupProjectNameLabel()
        setupAppTitleLabel()
        setupOKButton()

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
        completedLabel.hidden = false
        completedLabel.textColor = Colors.lightGray()
    }
    private func setupTimeLabel() {
        timeLabel.hidden = false
        timeLabel.text = workTimeFormatter.formatLong(numberOfCompletedSeconds)
        timeLabel.numberOfLines = 0
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
        project?.recordWork(numberOfCompletedSeconds)
    }
    //MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let segueIdentifier = segue.identifier {
            if segueIdentifier == "TimerDoneToTimeSlider" {
                let timeSliderVC = segue.destinationViewController as! TimeSliderViewController
                timeSliderVC.project = project
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
