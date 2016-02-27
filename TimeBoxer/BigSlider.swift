//
//  BigSlider.swift
//  TimeBoxer
//
//  Created by Tomasz Urbabowicz on 27/02/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class BigSlider: UIControl {
    var value:Double = 0.0
    let handleHeight = 20
    var fillColor:UIColor = UIColor.blackColor()
    var highlightedFillColor:UIColor = UIColor.grayColor()
    var cornerRadius:Double = 0.0
    
    private var startLocation = CGPoint()
    private var currentHeight:CGFloat = 0.0
    private var currentLocation = CGPoint()
    override func drawRect(rect: CGRect) {
        if (!highlighted) {
            fillColor.setFill()
        } else {
            highlightedFillColor.setFill()
        }
        
        let roundedRectPath = UIBezierPath(roundedRect: rect, cornerRadius: CGFloat(cornerRadius))
        roundedRectPath.fill()
        
        if highlighted {
            UIColor.whiteColor().setFill()
            let roundedRectHandle = CGRect(x: bounds.origin.x, y: currentHeight-20, width: bounds.width, height:20)
            let handlePath = UIBezierPath(roundedRect: roundedRectHandle, cornerRadius: 1.0)
            handlePath.fill()
        }
    }
    
    //MARK: Touch tracking
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        currentLocation = touch.locationInView(self)
        if bounds.contains(startLocation) {
            print("Begin tracking: \(touch.locationInView(self)) \(highlighted)")
            setNeedsDisplay()
            return true
        } else {
            return false
        }
        
    }
    
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        currentLocation = touch.locationInView(self)
        if !bounds.contains(currentLocation) {
            highlighted = false
            setNeedsDisplay()
            return false
        }
        print("Continue tracking: \(touch.locationInView(self)) \(highlighted)")
        setNeedsDisplay()
        return true
    }
    
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        print("End tracking: \(touch?.locationInView(self)) \(highlighted)")
        setNeedsDisplay()
    }
    
    private func boundCurrentLocation() {
        if currentLocation.y > bounds.height {
            currentLocation.y = bounds.height
        }
        if currentLocation.y < bounds.origin.y + CGFloat(handleHeight) {
            currentLocation.y = bounds.origin.y + CGFloat(handleHeight)
        }
    }
    
}
