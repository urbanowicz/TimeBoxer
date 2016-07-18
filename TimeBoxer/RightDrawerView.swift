//
//  RightDrawerView.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 14/06/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class RightDrawerView: UIView {
    var color = UIColor.whiteColor() {
        didSet {
            let shapeLayer = layer as! CAShapeLayer
            shapeLayer.strokeColor = color.CGColor
        }
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        initWithFrame(frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initWithFrame(CGRectZero)
    }
    
    override class func layerClass() -> AnyClass {
        return CAShapeLayer.self
    }
    
    private func initWithFrame(frame: CGRect) {
        let shapeLayer = layer as! CAShapeLayer
        shapeLayer.strokeColor = color.CGColor
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.lineWidth = 3.0
        shapeLayer.frame = frame
        shapeLayer.path = prepareShapePath(frame)
    }
    
    override func layoutSubviews() {
        let shapeLayer = layer as! CAShapeLayer
        shapeLayer.path = prepareShapePath(shapeLayer.bounds)
        shapeLayer.setNeedsDisplay()
    }
    
    private func prepareShapePath(rect:CGRect) -> CGPath {
        
        //create a smaller rect than the original one so that we have margins around the shape
        var innerRect = CGRectZero
        innerRect.size.width = rect.width - 0.45 * rect.width
        innerRect.size.height = innerRect.width
        innerRect.origin.x = rect.origin.x + (rect.width - innerRect.width)/2.0
        innerRect.origin.y = rect.origin.y + (rect.height - innerRect.height)/2.0
        
        //create the clock like shape
        let p1 = CGPoint(x:innerRect.origin.x + innerRect.width/2.0, y: innerRect.origin.y + innerRect.height/2.0)
        let length = 0.7 * (innerRect.height/2.0)
        let p2 = CGPoint(x:p1.x, y:p1.y - length)
        let p3 = CGPoint(x:p1.x + length, y:p1.y)
        let clockShapePath = UIBezierPath(ovalInRect:innerRect)
        clockShapePath.moveToPoint(p2)
        clockShapePath.addLineToPoint(p1)
        clockShapePath.addLineToPoint(p3)
        clockShapePath.lineWidth = 6.0
        return clockShapePath.CGPath
    }
    
}
