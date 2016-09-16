//
//  EditProjectNameViewController.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 14/09/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class EditProjectNameViewController: UIViewController, UITextFieldDelegate  {
    
    var delegate: SettingModifierDelegate?
    
    @IBOutlet weak var xButton: XButton!
    @IBOutlet weak var tickButton: TickButton!
    @IBOutlet weak var editProjectNameLabel: UILabel!
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var projectNameTextField: UITextField!
    @IBOutlet weak var lineSeparator: UIView!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.almostBlack()
        setupXButton()
        setupTickButton()
        setupEditProjectNameLabel()
        setupProjectNameLabel()
        setupProjectNameTextField()
        setupLineSeparator()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        projectNameTextField.performSelector(#selector(UITextField.becomeFirstResponder), withObject: nil, afterDelay: 0)
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
    
    private func setupTickButton() {
        tickButton.fillColor = Colors.green()
        tickButton.backgroundColor = Colors.almostBlack()
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
    
    private func setupProjectNameTextField() {
        projectNameTextField.delegate = self
        projectNameTextField.textColor = Colors.silver()
        projectNameTextField.adjustsFontSizeToFitWidth = true
    }
    private func setupLineSeparator() {
        lineSeparator.backgroundColor = Colors.silver().withAlpha(0.4)
    }
    private func setupProjectNameLabel() {
        projectNameLabel.textColor = Colors.silver().withAlpha(0.7)
        projectNameLabel.font = UIFont(name: "Avenir-Medium", size: 12)
        projectNameLabel.text = "PROJECT NAME"
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
      
        return true
    }
}
