//
//  AbstractOvalButton.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 04.11.2015.
//  Copyright © 2015 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class AbstractOvalButton: UIButton {
    
    var frontLayerColor = UIColor.whiteColor()
    var frontLayerHighlightedColor = UIColor.whiteColor()
    var frontLayerStrokeColor = UIColor.whiteColor()
    var frontLayerHighlighteStrokeColor = UIColor.whiteColor()
    var ovalLayerColor = UIColor.blackColor()
    var ovalLayerHighlightedColor = UIColor.grayColor()
    var borderColor = UIColor.greenColor()
    var borderWidth = 0.0
    
    override var highlighted: Bool {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var radius:CGFloat {
        get {
            return self.bounds.width/2.0
        }
    }
    
//----------------------------------------------------------------------------------------------------------------------
    override func drawRect(rect: CGRect)
    {
        var actualRect = rect
        
        if borderWidth > 0 {
            //If the border of the circle is to be drawn I want it to grow inside the bounding rect not outside of it
            let b = CGFloat(borderWidth)
            let actualOrigin = CGPoint(x: rect.origin.x + b, y: rect.origin.y + b)
            let actualSize = CGSize(width: rect.width - 2*b, height: rect.height - 2*b)
            actualRect = CGRect(origin: actualOrigin, size: actualSize)
        }
        
        let ovalPath = UIBezierPath(ovalInRect: actualRect)
        if !highlighted {
            ovalLayerColor.setFill()
        } else {
            ovalLayerHighlightedColor.setFill()
        }
        ovalPath.fill()

        if borderWidth > 0 {
            borderColor.setStroke()
            ovalPath.lineWidth = CGFloat(borderWidth)
            ovalPath.stroke()
        }
        if !highlighted {
            frontLayerStrokeColor.setStroke()
            frontLayerColor.setFill()
        } else {
            frontLayerHighlighteStrokeColor.setStroke()
            frontLayerHighlightedColor.setFill()
        }
        drawFrontLayer(rect)
        
    }

//----------------------------------------------------------------------------------------------------------------------
    func drawFrontLayer(rect: CGRect)
    {
        //implemented in subclasses
    }
}
