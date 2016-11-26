//
//  ChangeDailyGoalViewController.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 14/09/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class ChangeDailyGoalViewController: UIViewController, DurationPickerDelegate {
    
    var delegate: SettingModifierDelegate?
    var project:Project!
    
    @IBOutlet weak var xButton: XButton!
    @IBOutlet weak var tickButton: TickButton!
    @IBOutlet weak var changeDailyGoalLabel: UILabel!
    @IBOutlet weak var currentDailyGoalLabel: UILabel!
    @IBOutlet weak var currentDailyGoalValueLabel: UILabel!
    @IBOutlet weak var newDailyGoalLabel: UILabel!
    @IBOutlet weak var durationPicker: DurationPicker!
    private let minutesToTextConverter = MinutesToStringConverter()
    
    private var hidingTickButton = false
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.almostBlack()
        setupXbutton()
        setupTickButton()
        setupChangeDailyGoalLabel()
        setupCurrentDailyGoalLabel()
        setupCurrentDailyGoalValueLabel()
        setupNewDailyGoalLabel()
        setupDurationPicker()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        // Dispose of any resources that can be recreated.
    }
    
    private func setupXbutton() {
        xButton.borderWidth = 0.0
        xButton.frontLayerColor = Colors.silver()
        xButton.roundLayerColor = Colors.almostBlack()
        xButton.addTarget(self, action: #selector(xButtonPressed), forControlEvents: .TouchUpInside)
    }
    
    private func setupTickButton() {
        tickButton.fillColor = Colors.green()
        tickButton.backgroundColor = Colors.almostBlack()
        tickButton.hidden = true
        tickButton.addTarget(self, action: #selector(tickButtonPressed(_:)), forControlEvents: .TouchUpInside)
    }
    
    private func setupChangeDailyGoalLabel() {
        changeDailyGoalLabel.font = UIFont(name:"Avenir-Heavy", size: 24)
        changeDailyGoalLabel.text = "Change daily goal"
        changeDailyGoalLabel.textColor = Colors.silver()
        changeDailyGoalLabel.backgroundColor = Colors.almostBlack()
    }
    
    private func setupCurrentDailyGoalLabel() {
        currentDailyGoalLabel.textColor = Colors.silver().withAlpha(0.7)
        currentDailyGoalLabel.font = UIFont(name: "Avenir-Medium", size: 12)
        currentDailyGoalLabel.text = "CURRENT DAILY GOAL"
    }
    
    private func setupCurrentDailyGoalValueLabel() {
        currentDailyGoalValueLabel.text = minutesToTextConverter.convert(project.dailyGoalSeconds/60)
        currentDailyGoalValueLabel.textColor = Colors.silver()
        currentDailyGoalValueLabel.font = UIFont(name: "Menlo-Regular", size: 14)
    }
    
    private func setupNewDailyGoalLabel() {
        newDailyGoalLabel.textColor = Colors.silver().withAlpha(0.7)
        newDailyGoalLabel.font = UIFont(name: "Avenir-Medium", size: 12)
        newDailyGoalLabel.text = "NEW DAILY GOAL"
    }
    
    private func setupDurationPicker() {
        durationPicker.backgroundColor = UIColor.clearColor()
        durationPicker.scrollView.backgroundColor = Colors.green().withAlpha(0.07)
        durationPicker.delegate = self
        durationPicker.setDuration(project.dailyGoalSeconds)
    }
    
    func xButtonPressed() {
        //prevent the xButton from being pressed multiple times
        xButton.enabled = false
        tickButton.enabled = false
        delegate?.didCancelEditing(self)
    }
    func tickButtonPressed(sender:TickButton) {
        //prevent the tickButton from being pressed multiple times
        tickButton.enabled = false
        xButton.enabled = false
        project.dailyGoalSeconds = durationPicker.durationSeconds
        func prepareConfirmationBox() -> UILabel {
            let confirmationLabel = UILabel()
            confirmationLabel.frame = CGRectMake(0, 0, view.frame.width, 50)
            confirmationLabel.backgroundColor = Colors.green()
            confirmationLabel.font = UIFont(name: "Avenir-Heavy", size: 20)
            confirmationLabel.textColor = Colors.silver()
            confirmationLabel.text = ":)"
            confirmationLabel.transform = CGAffineTransformMakeTranslation(0, -confirmationLabel.frame.height)
            confirmationLabel.textAlignment = .Center
            return confirmationLabel
        }
        
        let confirmationBox = prepareConfirmationBox()
        view.addSubview(confirmationBox)
        
        let duration = 1.0
        let delay = 0.0
        let options = UIViewKeyframeAnimationOptions.CalculationModeLinear
        UIView.animateKeyframesWithDuration(duration, delay: delay, options: options, animations: {
            
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 1/4, animations: {
                confirmationBox.transform = CGAffineTransformIdentity
            })
            UIView.addKeyframeWithRelativeStartTime(1/2, relativeDuration: 1/4, animations: {
                confirmationBox.transform = CGAffineTransformMakeTranslation(0, -confirmationBox.frame.height)
            })
            
            }, completion: {finished in
                confirmationBox.removeFromSuperview()
                self.delegate?.didCommitEditing(self)
                
        })

    }
    
    func durationPickerDidChangeValue(picker:DurationPicker) {
        if tickButton.hidden {
            tickButton.alpha = 0
            tickButton.hidden = false
            UIView.animateWithDuration(0.3, animations: {self.tickButton.alpha = 1.0}, completion: { finished in self.tickButton.alpha = 1.0 })
        }
    }
    
    func durationPickerDidScroll(picker: DurationPicker) {
        if !tickButton.hidden && !hidingTickButton  {
            hidingTickButton = true
            UIView.animateWithDuration(0.3, animations: {self.tickButton.alpha = 0.0}, completion: { finished in self.tickButton.hidden = true
                self.hidingTickButton = false})
        }
    }
}
