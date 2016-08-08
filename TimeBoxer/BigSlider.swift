//
//  BigSlider.swift
//  TimeBoxer
//
//  Created by Tomasz Urbabowicz on 27/02/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class BigSlider: UIControl {
    let handleHeight:CGFloat = 40.0
    let cornerRadius:CGFloat = 6.0
    
    
    var fillColor:UIColor = UIColor.blackColor() {
        didSet {
            sliderLayer.backgroundColor = fillColor.CGColor
        }
    }
    
    override var frame:CGRect {
        didSet {
            sliderLayer.frame = rectToDraw()
        }
    }
    
    override var bounds:CGRect {
        didSet {
            currentHeight = CGFloat(value) * (bounds.height - handleHeight)
            sliderLayer.frame = rectToDraw()
            sliderLayer.setNeedsDisplay()
        }
    }
    
    var highlightedFillColor:UIColor = Colors.azure().withAlpha(0.7)
    
    var value:Double = 0.0
    
    private let sliderLayer = SliderLayer()
    private var startLocation = CGPoint()
    private var currentHeight:CGFloat = 0.0
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.backgroundColor = UIColor.clearColor()
        sliderLayer.cornerRadius = cornerRadius
        layer.addSublayer(sliderLayer)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }
    
    func refresh() {
        sliderLayer.backgroundColor = Colors.azure().CGColor
    }
    
    //MARK: Touch tracking
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        startLocation = touch.locationInView(self)
        let currentBounds = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width, height: handleHeight + currentHeight)
        if currentBounds.contains(startLocation) {
            sliderLayer.backgroundColor = highlightedFillColor.CGColor
            return true
        } else {
            return false
        }
        
    }
    
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        
        //1. Calculate how much we moved in the y direction and update the current height of the slider
        let currentLocation = touch.locationInView(self)
        let dy = currentLocation.y - startLocation.y
        
        startLocation = currentLocation
        currentHeight = currentHeight + dy
        
        //2. Make sure we don't move outside the bounds of the slider
        func boundCurrentHeight() {
            if currentHeight < 0 {
                currentHeight = 0
            }
            if currentHeight > bounds.height - handleHeight {
                currentHeight = bounds.height - handleHeight
            }
        }
        boundCurrentHeight()
        self.value = Double(currentHeight / (bounds.height - handleHeight))
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        sliderLayer.frame = rectToDraw()
        CATransaction.commit()
        sendActionsForControlEvents(.ValueChanged)
        return true
    }
    
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        sliderLayer.backgroundColor = fillColor.CGColor
    }
    
    func rectToDraw() -> CGRect {
        return CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width, height: handleHeight + currentHeight)
    }
    
}

class SliderLayer: CALayer {
    override var frame: CGRect {
        didSet {
            setNeedsDisplay()
        }
    }
}
