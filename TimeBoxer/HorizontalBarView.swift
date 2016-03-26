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
    
    override func drawRect(rect: CGRect) {
        let rectToDraw = CGRectMake(rect.origin.x, rect.origin.y, value * rect.width, rect.height)
        let path = UIBezierPath(roundedRect: rectToDraw, cornerRadius: cornerRadius)
        fillColor.setFill()
        path.fill()
    }


}
