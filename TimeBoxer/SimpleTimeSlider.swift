//
//  SimpleTimeSlider.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 24.10.2015.
//  Copyright © 2015 Tomasz Urbanowicz. All rights reserved.
//

import UIKit


class SimpleTimeSlider: UIControl {
    
    var headerX = 0.0
    var headerY = 0.0
    var headerWidth = 0.0
    var headerHeight = 0.0
    var headerHeightToBoundsHeightRatio = 0.16463414634146342
    
    var bodyX = 0.0
    var bodyY = 0.0
    var bodyWidth = 0.0
    var bodyHeight = 0.0
    var maxBodyHeight = 0.0
    var minBodyHeight = 0.0
    let bodyColor = UIColor(red:0.15, green:0.15, blue:0.15, alpha:1.0).CGColor
    let highlightedBodyColor = UIColor(red:0.58, green:0.58, blue:0.58, alpha:1.0).CGColor
    
    let minValue:Int = 5
    let maxValue:Int = 120
    var value:Int = 5
    var increment:Int = 5
    
    var numberOfDifferentValues:Int = 0
    var numberOfPixelPointsPerValue:Double = 0.0
    
    var previousLocation = CGPoint()
    
    let valueLabel = UILabel()
    let valueLabelFont = UIFont(name:"menlo", size: 23.0)
    let bodyLayer = TimeSliderBodyLayer()
    

//----------------------------------------------------------------------------------------------------------------------
    required init(coder: NSCoder) {
        super.init(coder: coder)
        bodyLayer.timeSlider = self
        layer.addSublayer(bodyLayer)
        valueLabel.textColor = UIColor.whiteColor()
        addSubview(valueLabel)
    }
    
//----------------------------------------------------------------------------------------------------------------------
    func frameIsReadyWithValue(value:Int) {
        
    }
    
//----------------------------------------------------------------------------------------------------------------------
    func frameIsReady() {
        let boundsHeight = Double(bounds.height)
        headerX = 0.0
        headerY = 0.0
        headerWidth = Double(bounds.width)
        headerHeight = headerHeightToBoundsHeightRatio * boundsHeight
        
        bodyX = headerX
        bodyY = headerY + headerHeight
        bodyWidth = headerWidth
        bodyHeight = 0.0
        minBodyHeight = 0.0
        maxBodyHeight = boundsHeight - headerHeight
        
        valueLabel.font = valueLabelFont
        
        numberOfDifferentValues = (maxValue - minValue) / increment + 1
        numberOfPixelPointsPerValue = maxBodyHeight / Double(numberOfDifferentValues)
        updateFrames()
    }
    
//----------------------------------------------------------------------------------------------------------------------
    func updateFrames() {
        bodyLayer.frame = CGRect(x:CGFloat(headerX), y:CGFloat(headerY),
            width: CGFloat(bodyWidth), height: CGFloat(bodyHeight + headerHeight))
        
        func updateValueLabelText() {
            let numberOfMinutesInOneHour = 60
            let numberOfHours = value / numberOfMinutesInOneHour
            let numberOfMinutes = value % numberOfMinutesInOneHour
            
            var numberOfMinutesText = ""
            if numberOfMinutes > 0 {
                if numberOfMinutes == 1 {
                    numberOfMinutesText = "1 minute"
                } else {
                    numberOfMinutesText = "\(numberOfMinutes) minutes"
                }
            }
            var numberOfHoursText = ""
            if numberOfHours > 0 {
                if numberOfHours == 1 {
                    numberOfHoursText = "1 hour"
                } else {
                    numberOfHoursText = "\(numberOfHours) hours"
                }
            }
            var space = ""
            if numberOfHours > 0 && numberOfMinutes > 0 {
                space = " "
            }
            valueLabel.text = numberOfHoursText + space +  numberOfMinutesText
            valueLabel.sizeToFit()
            valueLabel.frame.origin.x = CGFloat(headerWidth/2) - valueLabel.frame.width/2
            valueLabel.frame.origin.y = CGFloat(headerHeight/2) - valueLabel.frame.height/2
            valueLabel.setNeedsDisplay()
        }
        
        updateValueLabelText()
    }

//----------------------------------------------------------------------------------------------------------------------
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        previousLocation = touch.locationInView(self)
        if bodyLayer.frame.contains(previousLocation) {
            bodyLayer.highlighted = true
            return true
        }
        bodyLayer.highlighted = false
        return false
    }
    
//----------------------------------------------------------------------------------------------------------------------
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let location = touch.locationInView(self)
        let deltaLocation = Double(location.y - previousLocation.y)
        previousLocation = location
        
        func updateBodyHeight() {
            if bodyHeight + deltaLocation < maxBodyHeight {
                bodyHeight += deltaLocation
                if bodyHeight < minBodyHeight {
                    bodyHeight = minBodyHeight
                }
            } else {
                bodyHeight = maxBodyHeight
            }
        }
        updateBodyHeight()
        value = Int(floor(bodyHeight / numberOfPixelPointsPerValue) + 1) * increment
        if value > maxValue {
            value = maxValue
        }
        
        //Update the UI
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        updateFrames()
        CATransaction.commit()
        sendActionsForControlEvents(.ValueChanged)
        return true
    }
    
//----------------------------------------------------------------------------------------------------------------------
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        bodyLayer.highlighted = false
    }

}
