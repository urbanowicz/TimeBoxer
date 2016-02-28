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
    
    var fillColor:UIColor = UIColor.blackColor()
    
    var highlightedFillColor:UIColor {
        get {
            var red = CGFloat()
            var green = CGFloat()
            var blue = CGFloat()
            var alpha = CGFloat()
            fillColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            return UIColor(red: red, green: green, blue: blue, alpha: 0.70)
        }
    }
    
    var value:Double {
        get {
            return Double(currentHeight / (bounds.height - handleHeight))
        }
    }
    
    
    private var startLocation = CGPoint()
    private var currentHeight:CGFloat = 0.0
    
    override func drawRect(rect: CGRect) {
        if (!highlighted) {
            fillColor.setFill()
        } else {
            highlightedFillColor.setFill()
        }
        
        let rectToDraw = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width, height: handleHeight + currentHeight)
        let pathToDraw = UIBezierPath(roundedRect: rectToDraw, cornerRadius: cornerRadius)
        pathToDraw.fill()
        
    }
    
    //MARK: Touch tracking
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        startLocation = touch.locationInView(self)
        let currentBounds = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width, height: handleHeight + currentHeight)
        if currentBounds.contains(startLocation) {
            setNeedsDisplay()
            return true
        } else {
            return false
        }
        
    }
    
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        
        //1. Calculate how much we moved in the y direction and updated the current height of the slider
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
        setNeedsDisplay()
        sendActionsForControlEvents(.ValueChanged)
        return true
    }
    
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        setNeedsDisplay()
    }
    
}
