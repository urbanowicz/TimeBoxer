//
//  TimeSliderBodyLayer.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 24.10.2015.
//  Copyright © 2015 Tomasz Urbanowicz. All rights reserved.
//


import UIKit

class TimeSliderBodyLayer: CALayer {
    
    weak var timeSlider:SimpleTimeSlider?
    
    var highlighted : Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override var frame: CGRect {
        didSet {
            setNeedsDisplay()
        }
    }

//----------------------------------------------------------------------------------------------------------------------
    override func drawInContext(ctx: CGContext) {
        var color = timeSlider!.bodyColor
        if highlighted {
            color = timeSlider!.highlightedBodyColor
        }
        CGContextSetFillColorWithColor(ctx, color)
        let rect = CGRect(x: 0, y: 0, width: bounds.width, height:bounds.height)
        CGContextFillRect(ctx, rect)
    }
}
