//
//  PauseButton.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 02.11.2015.
//  Copyright © 2015 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class PauseButton: AbstractOvalButton {
    
    override func drawFrontLayer(rect: CGRect) {
        
        let currentContext = UIGraphicsGetCurrentContext()
        let a = rect.width
        let rx:CGFloat = 0.3333
        let ry:CGFloat = 0.3333
        let rw:CGFloat = 0.1
        let w = rw*a
        let h = a - 2*ry*a - w
        
        //Draw Rectangles
        let x1 = rx * a
        let y1 = ry * a + w/2
        let firstRect = CGRect(x:x1, y:y1, width:w, height:h)
        CGContextFillRect(currentContext, firstRect)
        
        let x2 = a - x1 - w
        let y2 = y1
        let secondRect = CGRect(x:x2, y:y2, width:w, height: h)
        CGContextFillRect(currentContext, secondRect)
        
        
        //Add arcs so that rectangles have rounded caps
        let pi = CGFloat(M_PI)
        var arcPathRef:CGMutablePathRef = CGPathCreateMutable()
        //Add arcs to the left rectangle
        CGPathAddArc(arcPathRef, nil, x1 + w/2.0, y1, w/2.0, 0, pi, true)
        CGPathAddArc(arcPathRef, nil, x1 + w/2.0, y1 + h, w/2.0, 0, pi, false)
        var arcPath = UIBezierPath(CGPath: arcPathRef)
        arcPath.fill()
        
        //Add arcs to the right rectangle
        arcPathRef = CGPathCreateMutable()
        CGPathAddArc(arcPathRef, nil, x2 + w/2.0, y2, w/2.0, 0, pi, true)
        CGPathAddArc(arcPathRef, nil, x2 + w/2.0, y2 + h, w/2.0, 0, pi, false)
        arcPath = UIBezierPath(CGPath: arcPathRef)
        arcPath.fill()
    }
}
