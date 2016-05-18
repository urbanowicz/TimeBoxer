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
        deleteProjectButton.backgroundColor = UIColor.redColor()
        deleteProjectButton.setTitle("Delete", forState:  UIControlState.Normal)
        deleteProjectButton.titleLabel!.font = UIFont(name: "Avenir Book", size: 20)
        deleteProjectButton.titleLabel!.textColor = Colors.almostBlack()
        deleteProjectButton.frame.size = CGSizeMake(projectNameLabel.frame.width, 50)
    }
    
    func setupCancelButton() {
        cancelButton.backgroundColor = UIColor.blueColor()
        cancelButton.setTitle("Cancel", forState: UIControlState.Normal)
        cancelButton.titleLabel!.font = UIFont(name: "Avenir Book", size: 20)
        cancelButton.titleLabel!.textColor = Colors.almostBlack()
        cancelButton.frame.size = CGSizeMake(projectNameLabel.frame.width, 50)
    }
}
