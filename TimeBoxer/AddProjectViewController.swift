//
//  AddProjectViewController.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 07.01.2016.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class AddProjectViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var projectNameTextField: UITextField!
//----------------------------------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        projectNameTextField.delegate = self
    }

//----------------------------------------------------------------------------------------------------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

//----------------------------------------------------------------------------------------------------------------------
//MARK: UITextFieldDelegate

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

//----------------------------------------------------------------------------------------------------------------------
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
    
}
