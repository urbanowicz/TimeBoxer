//
//  xButton.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 09/03/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class XButton: AbstractOvalButton {
    var strokeWidth = CGFloat(1.0)
    override func drawFrontLayer(rect: CGRect) {
        
        let scaleFactor = CGFloat(0.3)
        var smallerRect = CGRectZero
        smallerRect.size.height = rect.height * scaleFactor
        smallerRect.size.width = rect.width * scaleFactor
        smallerRect.origin.x = rect.origin.x + (rect.width - smallerRect.width) / 2.0
        smallerRect.origin.y = rect.origin.y + (rect.height - smallerRect.height) / 2.0
        strokeLine(smallerRect.origin.x, y1: smallerRect.origin.y,
            x2:smallerRect.origin.x + smallerRect.width , y2: smallerRect.origin.y + smallerRect.height)
        strokeLine(smallerRect.origin.x, y1: smallerRect.origin.y + smallerRect.height,
            x2: smallerRect.origin.x + smallerRect.width, y2: smallerRect.origin.y)
    
    }
    
    private func strokeLine(x1:CGFloat, y1:CGFloat, x2:CGFloat, y2:CGFloat) {
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: x1, y: y1))
        path.addLineToPoint(CGPoint(x: x2, y: y2))
        path.lineWidth = strokeWidth
        path.stroke()
    }
}
