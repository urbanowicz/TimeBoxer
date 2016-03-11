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
        var (height, numberOfLines) = heightAndNumberOfLinesForLabel(projectNameLabel, maxWidth:projectNameLabel.frame.width)
        if numberOfLines >= 2 {
            projectNameLabel.font = projectNameLabel.font.fontWithSize(14.0)
        }
        
//        var fontSize = projectNameLabel.font.pointSize
//        while  height > projectNameLabel.frame.height && fontSize > 14 {
//            fontSize -= 0.5
//            projectNameLabel.font = projectNameLabel.font.fontWithSize(fontSize)
//            (height, numberOfLines) = heightAndNumberOfLinesForLabel(projectNameLabel, maxWidth:projectNameLabel.frame.width)
//        }

    }
    
    private func heightAndNumberOfLinesForLabel(label:UILabel, maxWidth:CGFloat) -> (CGFloat, Int) {
        let text = label.text! as NSString
        let attributes = [NSFontAttributeName: label.font]
        let frameSize = CGSizeMake(maxWidth, CGFloat.max)
        let labelSize = text.boundingRectWithSize(frameSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributes, context: nil)
        let height = labelSize.height
        let numberOfLines = Int(ceil(height / label.font.lineHeight))
        return (height:height, numberOfLines:numberOfLines)
    }
}
