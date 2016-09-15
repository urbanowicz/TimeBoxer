//
//  EditProjectNameViewController.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 14/09/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class EditProjectNameViewController: UIViewController {
    
    var delegate: SettingModifierDelegate?
    
    @IBOutlet weak var xButton: XButton!
    @IBOutlet weak var editProjectNameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.almostBlack()
        setupXButton()
        setupEditProjectNameLabel()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupXButton() {
        xButton.borderWidth = 0.0
        xButton.frontLayerColor = Colors.silver()
        xButton.roundLayerColor = Colors.almostBlack()
        xButton.addTarget(self, action: #selector(xButtonPressed), forControlEvents: .TouchUpInside)
    }
    
    private func setupEditProjectNameLabel() {
        editProjectNameLabel.font = UIFont(name:"Avenir-Heavy", size: 24)
        editProjectNameLabel.text = "Edit project name"
        editProjectNameLabel.textColor = Colors.silver()
        editProjectNameLabel.backgroundColor = Colors.almostBlack()
    }
    
    func xButtonPressed() {
        delegate?.didCancelEditing(self)
    }
}
