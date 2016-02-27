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
    
    override func drawRect(rect: CGRect) {
        fillColor.setFill()
        let roundedRectPath = UIBezierPath(roundedRect: rect, cornerRadius: CGFloat(cornerRadius))
        roundedRectPath.fill()
    }
}
