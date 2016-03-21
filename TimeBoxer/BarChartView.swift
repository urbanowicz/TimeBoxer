//
//  BarChartView.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 17/03/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

@IBDesignable class BarChartView: UIView {

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let margin = CGFloat(0)
        let availableWidth = rect.width - CGFloat(2*margin)
        let barWidth = CGFloat(20)
        let barHeight = rect.height
        let gutter = (availableWidth - 7*barWidth) / 6.0
        
        UIColor.blueColor().setFill()
        
        var x = margin
        let y = rect.origin.y
        for _ in 1 ... 7 {
            let barRect = CGRectMake(x, y, barWidth, barHeight)
            CGContextFillRect(context, barRect)
            x += barWidth + gutter
        }
    }
}
