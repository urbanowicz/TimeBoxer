//
//  AddProjectViewController.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 07.01.2016.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class AddProjectViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var xButton: XButton!
    @IBOutlet weak var chooseProjectNameLabel: UILabel!
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var projectNameTextField: UITextField!
    @IBOutlet weak var lineSeparator: UIView!
    
    
    @IBOutlet weak var projectNameTextFieldCenterYConstraint: NSLayoutConstraint!
    var delegate:AddProjectPageDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        view.backgroundColor = Colors.almostBlack()
        setupXButton()
        setupChooseProjectNameLabel()
        setupProjectNameLabel()
        setupProjectNameTextField()
        setupLineSeparator()

    }
    
    override func viewDidAppear(animated: Bool) {
        projectNameTextField.performSelector(#selector(UITextField.becomeFirstResponder), withObject: nil, afterDelay: 0)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
//MARK: Setup UI Elements
    
    
    private func setupXButton() {
        xButton.borderWidth = 0.0
        xButton.frontLayerColor = Colors.silver()
        xButton.roundLayerColor = Colors.almostBlack()
    }
    
    private func setupChooseProjectNameLabel() {
        chooseProjectNameLabel.font = UIFont(name:"Avenir-Heavy", size: 22)
        chooseProjectNameLabel.text = "Choose a project name"
        chooseProjectNameLabel.textColor = Colors.silver()
        chooseProjectNameLabel.backgroundColor = Colors.almostBlack()
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
        projectNameLabel.textColor = Colors.silver().withAlpha(0.4)
        projectNameLabel.font = UIFont(name: "Avenir Book", size: 12)
        projectNameLabel.text = "PROJECT NAME"
    }

    
//MARK: Actions
    
    @IBAction func xButtonPressed(sender: XButton) {
        projectNameTextField.resignFirstResponder()
    }
//MARK: UITextFieldDelegate

    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
       
        let projectName = projectNameTextField!.text!
        delegate?.didChooseProjectName(projectName)
        delegate?.nextButtonPressed()
        return true
    }
    
}
