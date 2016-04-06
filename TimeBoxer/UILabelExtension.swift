//
//  UILabelExtension.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 06/04/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

extension UILabel {
    func heightAndNumberOfLinesWithWidth(maxWidth:CGFloat) -> (CGFloat, Int) {
        let text = self.text! as NSString
        let attributes = [NSFontAttributeName: self.font]
        let frameSize = CGSizeMake(maxWidth, CGFloat.max)
        let labelSize = text.boundingRectWithSize(frameSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributes, context: nil)
        let height = labelSize.height
        let numberOfLines = Int(ceil(height / self.font.lineHeight))
        return (height:height, numberOfLines:numberOfLines)
    }
}
