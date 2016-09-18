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
        delegate?.didCancelEditing(self)
    }
    func tickButtonPressed(sender:TickButton) {
        project.dailyGoalSeconds = durationPicker.durationSeconds
        delegate?.didCommitEditing(self)
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
