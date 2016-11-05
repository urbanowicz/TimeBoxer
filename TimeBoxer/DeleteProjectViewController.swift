//
//  DeleteProjectViewController.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 14/09/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class DeleteProjectViewController: UIViewController {
    
    var delegate: SettingModifierDelegate?
    var project: Project!
    @IBOutlet weak var xButton: XButton!
    @IBOutlet weak var deleteProjectLabel: UILabel!
    @IBOutlet weak var deleteConfirmationLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.almostBlack()
        setupXbutton()
        setupDeleteProjectLabel()
        setupDeleteConfirmationLabel()
        setupYesButton()
        setupNoButton()
        // Do any additional setup after loading the view.
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
    
    private func setupDeleteProjectLabel() {
        deleteProjectLabel.font = UIFont(name:"Avenir-Heavy", size: 24)
        deleteProjectLabel.text = "Delete Project"
        deleteProjectLabel.textColor = Colors.silver()
        deleteProjectLabel.backgroundColor = Colors.almostBlack()
    }
    
    private func setupDeleteConfirmationLabel() {
        let attrConfirmationString = NSMutableAttributedString(string: "Are you sure you want to delete ", attributes: [NSFontAttributeName: UIFont(name:"Avenir-Medium", size: 16)!,
            NSForegroundColorAttributeName: Colors.silver().withAlpha(0.7)])
        
        let attrProjectName = NSAttributedString(string: project.name, attributes: [NSFontAttributeName: UIFont(name:"Avenir-MediumOblique", size:16)!,
            NSForegroundColorAttributeName: Colors.silver().withAlpha(0.7)])
        
        let attrQuestionMark = NSMutableAttributedString(string: "?", attributes: [NSFontAttributeName: UIFont(name:"Avenir-Medium", size: 16)!,
            NSForegroundColorAttributeName: Colors.silver().withAlpha(0.7)])
        
        attrConfirmationString.appendAttributedString(attrProjectName)
        attrConfirmationString.appendAttributedString(attrQuestionMark)

        deleteConfirmationLabel.numberOfLines = 0
        deleteConfirmationLabel.backgroundColor = Colors.almostBlack()
        deleteConfirmationLabel.attributedText = attrConfirmationString
    }
    
    private func setupYesButton() {
        yesButton.titleLabel?.font = UIFont(name:"Avenir-Medium", size: 20)
        yesButton.titleLabel?.text = "Yes"
        yesButton.tintColor = Colors.silver()
        yesButton.backgroundColor = Colors.red()
        yesButton.layer.borderColor = Colors.silver().CGColor
        yesButton.layer.borderWidth = 1
        yesButton.layer.cornerRadius = 4
        yesButton.clipsToBounds = true
    }
    
    private func setupNoButton() {
        noButton.titleLabel?.font = UIFont(name:"Avenir-Medium", size: 20)
        noButton.titleLabel?.text = "No"
        noButton.tintColor = Colors.silver()
        noButton.backgroundColor = Colors.almostBlack()
        noButton.layer.borderColor = Colors.silver().CGColor
        noButton.layer.borderWidth = 1
        noButton.layer.cornerRadius = 4
        noButton.clipsToBounds = true
    }
    
    func xButtonPressed() {
        delegate?.didCancelEditing(self)
    }
    
    
    @IBAction func noButtonPressed(sender: UIButton) {
        delegate?.didCancelEditing(self)
    }

    @IBAction func yesButtonPressed(sender: AnyObject) {
        delegate?.didCommitEditing(self)
    }
}
