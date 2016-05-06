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
    override func awakeFromNib() {
        super.awakeFromNib()
    
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
}
