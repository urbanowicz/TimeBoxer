//
//  OKButton.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 02/03/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class OKButton: AbstractOvalButton {
    override func drawFrontLayer(rect: CGRect) {
        let originX = rect.origin.x
        let originY = rect.origin.y
        let width = rect.width
        
        let rect1Width = 0.618*0.618*0.618 * width
        let rect2Width = 1.4 * rect1Width
        let xc = originX + 0.5 * width
        let yc = originY + 0.66 * width
        let rect1X = xc - rect1Width
        let rect1Y = yc - rect1Width
        
        let rect2Y = yc - rect2Width
        
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: rect1X, y: rect1Y))
        path.addLineToPoint(CGPoint(x: xc, y: yc))
        path.addLineToPoint(CGPoint(x: xc + rect2Width, y: rect2Y))
        path.stroke()
    }
}
