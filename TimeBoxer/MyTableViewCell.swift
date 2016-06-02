//
//  MyTableViewCell.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 19/01/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    var project:Project?
    
    @IBOutlet weak var cellSeparator: UIView!
    @IBOutlet weak var lastWorkedOnLabel: UILabel!
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var facadeView: UIView!
    @IBOutlet weak var leftDrawer: UIView!
    @IBOutlet weak var rightDrawer: UIView!
    @IBOutlet var projectNameLabelBottomToFacadeViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var projectNameLabelTrailingSpaceToFacadeViewConstraint: NSLayoutConstraint!
    @IBOutlet var projectNameLabelTopToFacadeViewConstraint: NSLayoutConstraint!
    @IBOutlet var projectNameLabelLeadingSpaceToFacadeViewConstraint: NSLayoutConstraint!
    var deleteProjectButton:UIButton = UIButton(type: UIButtonType.System)
    var cancelButton:UIButton = UIButton(type: UIButtonType.System)

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func adjustFontSizeToFitTheFrame() {
        projectNameLabel.numberOfLines = 0
        projectNameLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        let (_,  numberOfLines) = projectNameLabel.heightAndNumberOfLinesWithWidth(projectNameLabel.frame.width)
        if numberOfLines >= 2 {
            projectNameLabel.font = projectNameLabel.font.fontWithSize(14.0)
        }
    }
    
    func setupDeleteProjectButton() {
        deleteProjectButton.backgroundColor = Colors.almostBlack()
        deleteProjectButton.tintColor = Colors.silver()
        deleteProjectButton.setTitle("Delete", forState:  UIControlState.Normal)
        deleteProjectButton.titleLabel!.font = UIFont(name: "Avenir Book", size: 20)
        deleteProjectButton.frame.size = CGSizeMake(projectNameLabel.frame.width, 50)
        deleteProjectButton.clipsToBounds = true
        deleteProjectButton.layer.borderColor = Colors.silver().CGColor
        deleteProjectButton.layer.borderWidth = 1.0
        deleteProjectButton.layer.cornerRadius = 0.05 * deleteProjectButton.frame.width
    }
    
    func setupCancelButton() {
        cancelButton.backgroundColor = Colors.almostBlack()
        cancelButton.tintColor = Colors.silver()
        cancelButton.setTitle("Cancel", forState: UIControlState.Normal)
        cancelButton.titleLabel!.font = UIFont(name: "Avenir Book", size: 20)
        cancelButton.titleLabel!.textColor = Colors.almostBlack()
        cancelButton.frame.size = CGSizeMake(projectNameLabel.frame.width, 50)
        cancelButton.clipsToBounds = true
        cancelButton.layer.borderColor = Colors.silver().CGColor
        cancelButton.layer.borderWidth = 1.0
        cancelButton.layer.cornerRadius = 0.05 * cancelButton.frame.width
    }
}
