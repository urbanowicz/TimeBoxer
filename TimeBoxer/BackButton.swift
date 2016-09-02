//
//  BackButton.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 02/09/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class BackButton: AbstractRoundButton {
    
    override func prepareFrontShapePath() -> CGPath {
        let dx = CGFloat(10)
        let w = bounds.width
        let h = bounds.height
        
        let path:CGMutablePathRef = CGPathCreateMutable()
        goto(path, p(0, h))
        arc(path, p(w, h), p(w,h - dx/2.0))
        arc(path, p(w, h - dx), p(dx, h - dx))
        line(path, p(dx, h - dx))
        arc(path, p(dx, 0), p(dx/2.0, 0))
        arc(path, p(0,0), p(0, h))
        CGPathCloseSubpath(path)
        
        frontLayer.anchorPoint = CGPointMake(0.5, 0.5)
        let scaleFactor = CGFloat(0.33)
        let rotation = CGAffineTransformMakeRotation(0.785398)
        let scale = CGAffineTransformMakeScale(scaleFactor, scaleFactor)
        //let translation = CGAffineTransformMakeTranslation(a, 0)
        //let combined = CGAffineTransformConcat(rotation, scale)
        let finalTransform = CGAffineTransformConcat(rotation, scale)
        frontLayer.transform = CATransform3DMakeAffineTransform(finalTransform)
        return path
    }
    
    private func arc(path:CGMutablePathRef, _ p1:CGPoint, _ p2:CGPoint) {
        let radius = CGFloat(2.5)
        CGPathAddArcToPoint(path, nil, p1.x, p1.y, p2.x, p2.y, radius)
    }
    
    private func goto(path:CGMutablePathRef, _ p:CGPoint) {
        CGPathMoveToPoint(path, nil, p.x, p.y)
    }
    
    private func line(path:CGMutablePathRef, _ p:CGPoint) {
        CGPathAddLineToPoint(path, nil, p.x, p.y)
    }
    
    private func p(x:CGFloat, _ y:CGFloat) -> CGPoint {
        return CGPointMake(x, y)
    }
}
