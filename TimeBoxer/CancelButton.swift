//
//  CancelButton.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 04.11.2015.
//  Copyright © 2015 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class CancelButton: AbstractOvalButton {

    override func drawFrontLayer(rect: CGRect) {
        let rx = CGFloat(0.333)
        let ry = CGFloat(0.333)
        let rThickness = CGFloat(0.07)
        let a = rect.width
        
        let x1 = rx * a
        let y1 = ry * a
        let x2 = a - x1
        let y2 = a - y1
        let x3 = x1
        let y3 = y2
        let x4 = x2
        let y4 = y1
        let thickness = rThickness * a
        let sqrt2 = CGFloat(1.4142135623730951)
        let b = CGFloat(thickness) / sqrt2
        
        
        let xPath1 = UIBezierPath()
        xPath1.moveToPoint(CGPoint(x: x1 - b, y: y1 + b))
        xPath1.addLineToPoint(CGPoint(x: x1 + b, y: y1 - b))
        xPath1.addLineToPoint(CGPoint(x: x2 + b, y: y2 - b))
        xPath1.addLineToPoint(CGPoint(x: x2 - b, y: y2 + b))
        xPath1.closePath()
        
        let xPath2 = UIBezierPath()
        xPath2.moveToPoint(CGPoint(x: x3 - b, y: y3 - b))
        xPath2.addLineToPoint(CGPoint(x: x3 + b, y: y3 + b))
        xPath2.addLineToPoint(CGPoint(x: x4 + b, y: y4 + b))
        xPath2.addLineToPoint(CGPoint(x: x4 - b, y: y4 - b))
        xPath2.closePath()
        
        xPath1.fill()
        xPath2.fill()
    }

}
