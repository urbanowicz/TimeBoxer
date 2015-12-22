//
//  PauseButton.swift
//  TimeBoxer_v0
//
//  Created by Tomasz on 02.11.2015.
//  Copyright © 2015 Tomasz. All rights reserved.
//

import UIKit

class PauseButton: UIButton {
    
    var pauseLayerColor = UIColor.whiteColor()
    var ovalLayerColor = UIColor(red:0.15, green:0.15, blue:0.15, alpha:1.0)
    var pauseLayerHighlightedColor = UIColor.whiteColor()
    var ovalLayerHighlightedColor = UIColor(red:0.58, green:0.58, blue:0.58, alpha:1.0)
    
    override var highlighted:Bool {
        didSet {
            setNeedsDisplay()
        }
    }
    override func drawRect(rect: CGRect) {
        
        let ovalPath = UIBezierPath(ovalInRect: rect)
        if !highlighted {
            ovalLayerColor.setFill()
        } else {
            ovalLayerHighlightedColor.setFill()
        }
        ovalPath.fill()
        
        if !highlighted {
            pauseLayerColor.setFill()
        } else {
            pauseLayerHighlightedColor.setFill()
        }
        let currentContext = UIGraphicsGetCurrentContext()
        let a = rect.width
        let rx:CGFloat = 0.3333
        let ry:CGFloat = 0.3333
        let rw:CGFloat = 0.1
        let w = rw*a
        let h = a - 2*ry*a
        
        let x1 = rx * a
        let y1 = ry * a
        let firstRect = CGRect(x:x1, y:y1, width:w, height:h)
        CGContextFillRect(currentContext, firstRect)
        
        let x2 = a - x1 - w
        let y2 = y1
        let secondRect = CGRect(x:x2, y:y2, width:w, height: h)
        CGContextFillRect(currentContext, secondRect)

    }
}
