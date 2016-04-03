//
//  HorizontalBarView.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 18/03/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

@IBDesignable
class HorizontalBarView: UIView {
    @IBInspectable var fillColor:UIColor = UIColor.redColor()
    @IBInspectable var cornerRadius:CGFloat = CGFloat(0.0)
    @IBInspectable var value:CGFloat = CGFloat(1.0) //Value between 0.0 and 0.1
    var innerLabel: UILabel?
    var outerLabel: UILabel?
    var labelText: String?
    
    override func drawRect(rect: CGRect) {
        let rectToDraw = CGRectMake(rect.origin.x, rect.origin.y, value * rect.width, rect.height)
        let path = UIBezierPath(roundedRect: rectToDraw, cornerRadius: cornerRadius)
        fillColor.setFill()
        path.fill()
        
        layoutInnerLabel(rectToDraw)
        layoutOuterLabel(rectToDraw)

    }
    
    private func layoutInnerLabel(rectToDraw: CGRect) {
        if let label = innerLabel {
            if let text = labelText {
                label.text = text
            }
            label.sizeToFit()
            label.frame.origin.x = rectToDraw.width - label.bounds.width - 5
            label.frame.origin.y = rectToDraw.height/2.0 - label.frame.height/2.0
            if label.bounds.width > rectToDraw.width - 10 {
                label.hidden = true
            } else {
                label.hidden = false
            }
        }
    }
    
    private func layoutOuterLabel(rectToDraw: CGRect) {
        if let label = outerLabel {
            if let text = labelText {
                label.text = text
            }
            label.sizeToFit()
            label.frame.origin.x = rectToDraw.width + 5
            label.frame.origin.y = rectToDraw.height/2.0 - label.frame.height/2.0
            if label.bounds.width > rectToDraw.width - 10 {
                label.hidden = false
            } else {
                label.hidden = true
            }
        }
    }
}
