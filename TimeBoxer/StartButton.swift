//
//  StartButton.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 31.10.2015.
//  Copyright © 2015 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class StartButton: AbstractRoundButton {
    

    override func prepareFrontShapePath() -> CGPath {
        
        let scaleFactor = CGFloat(0.3333333)
        let sqrt3 = CGFloat(1.7320508075688772)
        let a = bounds.width * scaleFactor
        
        let x1 = a + 7
        let y1 = a
        let topLeft = CGPoint(x: x1,y: y1)
        let x2 = x1 + a * sqrt3 * 0.5
        let y2 = y1 + a * 0.5
        let middleRight = CGPoint(x: x2, y: y2)
        let x3 = x1
        let y3 = y1 + a
        let bottomLeft = CGPoint(x: x3, y: y3)
        let start = CGPoint(x: topLeft.x, y: topLeft.y + (a / 2.0))
        
        let radius = CGFloat(2.5)
        let path:CGMutablePathRef = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, start.x, start.y)
        CGPathAddArcToPoint(path, nil, bottomLeft.x, bottomLeft.y, middleRight.x, middleRight.y, radius)
        CGPathAddArcToPoint(path, nil, middleRight.x, middleRight.y, topLeft.x, topLeft.y, radius)
        CGPathAddArcToPoint(path, nil, topLeft.x, topLeft.y, start.x, start.y, radius)
        CGPathCloseSubpath(path)
        return path
    }
    
}
