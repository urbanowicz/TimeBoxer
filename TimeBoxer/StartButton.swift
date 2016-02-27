//
//  StartButton.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 31.10.2015.
//  Copyright © 2015 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class StartButton: AbstractOvalButton {
    
    override func drawFrontLayer(rect: CGRect) {
        //draw the triangle layer
        let scaleFactor = CGFloat(0.3333333)
        let sqrt3 = CGFloat(1.7320508075688772)
        let a = rect.width * scaleFactor
        
        let x1 = a + 5
        let y1 = a
        let p1 = CGPoint(x: x1,y: y1)
        let x2 = x1 + a * sqrt3 * 0.5
        let y2 = y1 + a * 0.5
        let p2 = CGPoint(x: x2, y: y2)
        let x3 = x1
        let y3 = y1 + a
        let p3 = CGPoint(x: x3, y: y3)
        
        let trianglePath = UIBezierPath()
        trianglePath.moveToPoint(p1)
        trianglePath.addLineToPoint(p2)
        trianglePath.addLineToPoint(p3)
        trianglePath.closePath()
        trianglePath.fill()
    }

}
