//
//  SetDailyGoalViewController.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 30/08/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class SetDailyGoalViewController: UIViewController {
    var delegate:SetDailyGoalPageDelegate?
    
    @IBOutlet weak var backButton: BackButton!
    @IBOutlet weak var setDailyGoalLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dailyGoalLabel: UILabel!
    @IBOutlet weak var okButton: OKButton!
    @IBOutlet weak var durationPicker: DurationPicker!
    
    private let sliderValueConverter = SliderOutputToValueConverter(maxValue: 480, resolution: 5)
    private let minutesToTextConverter = MinutesToStringConverter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.almostBlack()
        setupBackButton()
        setupSetDailyGoalLabel()
        setupDescriptionLabel()
        setupDailyGoalLabel()
        setupDurationPicker()
        setupOkButton()
    }
    
    private func setupDurationPicker() {
        durationPicker.backgroundColor = UIColor.clearColor()
        durationPicker.scrollView.backgroundColor = Colors.green().withAlpha(0.07)
    }
    
    private func setupBackButton() {
        backButton.frontLayerColor = Colors.silver()
        backButton.roundLayerColor = Colors.almostBlack()
    }
    
    private func setupSetDailyGoalLabel() {
        setDailyGoalLabel.font = UIFont(name:"Avenir-Heavy", size: 24)
        setDailyGoalLabel.text = "Set daily goal"
        setDailyGoalLabel.textColor = Colors.silver()
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.font = UIFont(name:"Avenir-Medium", size:15)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = Colors.silver().withAlpha(0.7)
        descriptionLabel.backgroundColor = Colors.almostBlack()
        descriptionLabel.text = "Choose how much time every day you'd like to spend working on the project. You can change this value later."
    }
    
    private func setupDailyGoalLabel() {
        dailyGoalLabel.textColor = Colors.silver().withAlpha(0.7)
        dailyGoalLabel.font = UIFont(name: "Avenir-Medium", size: 12)
        dailyGoalLabel.text = "DAILY GOAL"
    }
    
    private func setupOkButton() {
        okButton.frontLayerColor = Colors.silver()
        okButton.frontLayerStrokeColor = Colors.silver()
        okButton.frontLayerHighlighteStrokeColor = Colors.silver()
        okButton.ovalLayerColor = Colors.almostBlack()
        okButton.ovalLayerHighlightedColor = Colors.almostBlack()
        okButton.borderColor = Colors.silver()
        okButton.borderWidth = 2.0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        delegate?.didPressBackButton()
    }
    @IBAction func okButtonPressed(sender: AnyObject) {
        //disable the ok button so that it can't be pressed multiple times
        okButton.enabled = false
        delegate?.didSetDailyGoal(durationPicker.durationSeconds)
    }

}
