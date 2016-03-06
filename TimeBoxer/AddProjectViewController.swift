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
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var projectNameTextField: UITextField!
    var projectName:String?
//----------------------------------------------------------------------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
        projectNameTextField.delegate = self
        projectNameTextField.textColor = Colors.toUIColor(.ALMOST_BLACK)
        
        newProjectLabel.textColor = Colors.toUIColor(.OFF_WHITE)
        headerView.backgroundColor = UIColor(red:0.478, green:0.263, blue:0.451, alpha:1)
       
    }
    
    override func viewDidAppear(animated: Bool) {
        projectNameTextField.becomeFirstResponder()
    }

//----------------------------------------------------------------------------------------------------------------------
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

//----------------------------------------------------------------------------------------------------------------------
//MARK: UITextFieldDelegate

    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        
        //textField.resignFirstResponder()
        performSegueWithIdentifier("ProjectAddedUnwind", sender: self)
        return true
    }

//----------------------------------------------------------------------------------------------------------------------
    func textFieldDidEndEditing(textField: UITextField)
    {
        projectName = projectNameTextField!.text
        
    }

//----------------------------------------------------------------------------------------------------------------------
//MARK: Status Bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent
    }
    
}
