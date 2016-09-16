//
//  TickButton.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 16/09/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class TickButton: UIControl {
    var fillColor: UIColor?
    
    override func drawRect(rect: CGRect) {
        let frame = rect
        
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()
        
        //// Group
        //// Rectangle Drawing
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, frame.minX + 7.49, frame.minY + 18.91)
        CGContextRotateCTM(context, -45 * CGFloat(M_PI) / 180)
        
        let rectanglePath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 4.32, height: 10.68), cornerRadius: 1.4)
        fillColor?.setFill()
        rectanglePath.fill()
        
        CGContextRestoreGState(context)
        
        
        //// Rectangle 2 Drawing
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, frame.minX + 14.4, frame.minY + 26.65)
        CGContextRotateCTM(context, 45 * CGFloat(M_PI) / 180)
        
        let rectangle2Path = UIBezierPath(roundedRect: CGRect(x: -3.38, y: -20.68, width: 4.53, height: 19.39), cornerRadius: 1.4)
        fillColor?.setFill()
        rectangle2Path.fill()
        
        CGContextRestoreGState(context)
    }
 

}
