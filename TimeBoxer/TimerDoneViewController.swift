//
//  TimerDoneViewController.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 02/03/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class TimerDoneViewController: UIViewController {

    @IBOutlet weak var appTitleLabel: UILabel!
    @IBOutlet weak var completedLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var ofLabel: UILabel!
    @IBOutlet weak var projectName: UILabel!
    
    @IBOutlet weak var okButton: OKButton!
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
        timeLabel.textColor = Colors.almostBlack()
    }
    private func setupOfLabel() {
        ofLabel.textColor = Colors.lightGray()
    }
    private func setupProjectNameLabel() {
        projectName.textColor = Colors.almostBlack()
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
