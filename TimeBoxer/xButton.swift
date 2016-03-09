//
//  xButton.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 09/03/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class xButton: AbstractOvalButton {
    var strokeWidth = CGFloat(1.0)
    override func drawFrontLayer(rect: CGRect) {
        
        strokeLine(rect.origin.x, y1: rect.origin.y,
            x2:rect.origin.x + rect.width , y2: rect.origin.y + rect.height)
        strokeLine(rect.origin.x, y1: rect.origin.y + rect.height,
            x2: rect.origin.x + rect.width, y2: rect.origin.y)
    
    }
    
    private func strokeLine(x1:CGFloat, y1:CGFloat, x2:CGFloat, y2:CGFloat) {
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: x1, y: y1))
        path.addLineToPoint(CGPoint(x: x2, y: y2))
        path.lineWidth = strokeWidth
        path.stroke()
    }
}
