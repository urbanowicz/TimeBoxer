//
//  RightDrawerView.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 14/06/16.
//  Copyright © 2016 Tomasz. All rights reserved.
//

import UIKit

class RightDrawerView: UIView {
    var color = UIColor.whiteColor()
    
    override func drawRect(rect:CGRect) {
        var innerRect = CGRectZero
        innerRect.size.width = rect.width - 0.45 * rect.width
        innerRect.size.height = innerRect.width
        innerRect.origin.x = rect.origin.x + (rect.width - innerRect.width)/2.0
        innerRect.origin.y = rect.origin.y + (rect.height - innerRect.height)/2.0
        
        doDraw(innerRect)
    }
    func doDraw(rect: CGRect) {

        let circlePath = UIBezierPath(ovalInRect: rect)
        circlePath.lineWidth = 4.0
        color.setStroke()
        circlePath.stroke()
        
        let p1 = CGPoint(x:rect.origin.x + rect.width/2.0, y: rect.origin.y + rect.height/2.0)
        let length = 0.7 * (rect.height/2.0)
        let p2 = CGPoint(x:p1.x, y:p1.y - length)
        let p3 = CGPoint(x:p1.x + length, y:p1.y)
        let linePath = UIBezierPath()
        linePath.moveToPoint(p2)
        linePath.addLineToPoint(p1)
        linePath.addLineToPoint(p3)
        linePath.lineWidth = 3.0
        linePath.stroke()

    }
    
}
