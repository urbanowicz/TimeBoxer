//
//  AddProjectViewController.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 07.01.2016.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class AddProjectViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var newProjectLabel: UILabel!
    
    @IBOutlet weak var titleBar: TitleBar!
    @IBOutlet weak var projectNameTextField: UITextField!
    @IBOutlet weak var lineSeparator: UIView!
    @IBOutlet weak var projectNameLabel: UILabel!
    
    var projectName:String?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupTitleBar()
        //setupNewProjectLabel()
        setupProjectNameTextField()
        setupLineSeparator()
        setupProjectNameLabel()
    }
    
    override func viewDidAppear(animated: Bool) {
        projectNameTextField.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
//MARK: Setup UI Elements
    
    private func setupTitleBar() {
        titleBar.fillColor = Colors.purple()
        titleBar.cornerRadius = 6.0
    }

    private func setupNewProjectLabel() {
        newProjectLabel.textColor = Colors.offWhite()
    }
    private func setupProjectNameTextField() {
        projectNameTextField.delegate = self
        projectNameTextField.textColor = Colors.almostBlack()
        projectNameTextField.adjustsFontSizeToFitWidth = true
    }
    private func setupLineSeparator() {
        lineSeparator.backgroundColor = Colors.kindOfGray()
    }
    private func setupProjectNameLabel() {
        projectNameLabel.textColor = Colors.kindOfGray()
    }
    

//MARK: UITextFieldDelegate

    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        
        //textField.resignFirstResponder()
        performSegueWithIdentifier("ProjectAddedUnwind", sender: self)
        return true
    }


    func textFieldDidEndEditing(textField: UITextField)
    {
        projectName = projectNameTextField!.text
        
    }


//MARK: Status Bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent
    }
    
}
