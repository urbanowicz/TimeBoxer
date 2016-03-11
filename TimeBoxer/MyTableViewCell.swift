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
    var panGestureRecognizerDelegate:ProjectsTableCellPanGestureDelegate?
    
    @IBOutlet weak var lastWorkedOnLabel: UILabel!
    @IBOutlet weak var projectNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func adjustFontSizeToFitTheFrame() {
        projectNameLabel.numberOfLines = 0
        projectNameLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        var height = heightForLabel(projectNameLabel, maxWidth:projectNameLabel.frame.width)
        var fontSize = projectNameLabel.font.pointSize
        while height > projectNameLabel.frame.height && fontSize > 13.5 {
            fontSize -= 0.5
            projectNameLabel.font = projectNameLabel.font.fontWithSize(fontSize)
            height = heightForLabel(projectNameLabel, maxWidth:projectNameLabel.frame.width)
        }
    }
    
    private func heightForLabel(label:UILabel, maxWidth:CGFloat) -> CGFloat {
        let text = label.text! as NSString
        let attributes = [NSFontAttributeName: label.font]
        let frameSize = CGSizeMake(maxWidth, CGFloat.max)
        let labelSize = text.boundingRectWithSize(frameSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributes, context: nil)
        return labelSize.height
    }
}
