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
    
    override func drawRect(rect: CGRect) {
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        fillColor.setFill()
        path.fill()
    }


}
