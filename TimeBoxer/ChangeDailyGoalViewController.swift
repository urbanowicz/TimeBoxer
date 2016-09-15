//
//  ChangeDailyGoalViewController.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 14/09/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class ChangeDailyGoalViewController: UIViewController {
    
    var delegate: SettingModifierDelegate?
    @IBOutlet weak var xButton: XButton!
    @IBOutlet weak var changeDailyGoalLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.almostBlack()
        setupXbutton()
        setupChangeDailyGoalLabel()
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
    
    private func setupChangeDailyGoalLabel() {
        changeDailyGoalLabel.font = UIFont(name:"Avenir-Heavy", size: 24)
        changeDailyGoalLabel.text = "Change daily goal"
        changeDailyGoalLabel.textColor = Colors.silver()
        changeDailyGoalLabel.backgroundColor = Colors.almostBlack()
    }
    
    func xButtonPressed() {
        delegate?.didCancelEditing(self)
    }

}
