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
        let ovalPath = UIBezierPath(ovalInRect: rect)
        if !highlighted {
            ovalLayerColor.setFill()
        } else {
            ovalLayerHighlightedColor.setFill()
        }
        ovalPath.fill()
        if !highlighted {
            frontLayerColor.setFill()
        } else {
            frontLayerHighlightedColor.setFill()
        }
        if borderWidth > 0 {
            borderColor.setStroke()
            ovalPath.lineWidth = CGFloat(borderWidth)
            ovalPath.stroke()
        }
        drawFrontLayer(rect)
        
    }

//----------------------------------------------------------------------------------------------------------------------
    func drawFrontLayer(rect: CGRect)
    {
        //implemented in subclasses
    }
}
