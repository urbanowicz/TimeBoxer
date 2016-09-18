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
    var project: Project!
    
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
        tickButton.hidden = true
        tickButton.addTarget(self, action: #selector(tickButtonPressed(_:)), forControlEvents: .TouchUpInside)
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
        projectNameTextField.text = project.name
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
        tickButtonPressed(tickButton)
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if string == "" && range.length == textField.text!.characters.count {
            UIView.animateWithDuration(0.3, animations: {self.tickButton.alpha = 0 },
                completion: { finished in self.tickButton.hidden = true})
            return true
        }
        
        if tickButton.hidden {
            tickButton.alpha = 0
            tickButton.hidden = false
            let tickButtonAlphaAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            tickButtonAlphaAnimation.duration = 0.3
            tickButtonAlphaAnimation.toValue = 1.0
            tickButtonAlphaAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            tickButton.pop_addAnimation(tickButtonAlphaAnimation, forKey: "alpha")
        }
        return true
    }
    
    func tickButtonPressed(sender:TickButton) {
        project.name = projectNameTextField.text!
        delegate?.didCommitEditing(self)
    }
}
