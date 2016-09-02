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
    @IBOutlet weak var dailyGoalLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var dailyGoalValueLabel: UILabel!
    @IBOutlet weak var okButton: OKButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.almostBlack()
        setupBackButton()
        setupSetDailyGoalLabel()
        setupDailyGoalLabel()
        setupSlider()
        setupDailyGoalValueLabel()
        setupOkButton()
    }
    
    private func setupBackButton() {
        backButton.frontLayerColor = Colors.silver()
        backButton.roundLayerColor = Colors.almostBlack()
    }
    
    private func setupSetDailyGoalLabel() {
        setDailyGoalLabel.font = UIFont(name:"Avenir-Heavy", size: 22)
        setDailyGoalLabel.text = "Set daily goal"
        setDailyGoalLabel.textColor = Colors.silver()
    }
    
    private func setupDailyGoalLabel() {
        dailyGoalLabel.textColor = Colors.silver().withAlpha(0.4)
        dailyGoalLabel.font = UIFont(name: "Avenir Book", size: 12)
        dailyGoalLabel.text = "DAILY GOAL"
    }
    
    private func setupSlider() {

    }
    
    private func setupDailyGoalValueLabel() {
        dailyGoalValueLabel.font = UIFont(name: "Avenir-Medium", size: 18)
        dailyGoalValueLabel.text = "2 hours, 15 minutes"
        dailyGoalValueLabel.textColor = Colors.silver()
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
        delegate?.didSetDailyGoal(3600)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
