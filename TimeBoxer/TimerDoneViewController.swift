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
        okButton.ovalLayerHighlightedColor = Colors.almostBlack()
        okButton.frontLayerHighlighteStrokeColor = Colors.seafoam()
        okButton.borderWidth = 2.0
    }
}
