//
//  TitleBar.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 08/03/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class TitleBar: UIView {
    var cornerRadius = 6.0
    var fillColor = UIColor.blackColor()
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    override func drawRect(rect: CGRect) {
        let corners = UIRectCorner.BottomLeft.union(UIRectCorner.BottomRight)
        let radius = CGSize(width: cornerRadius, height: cornerRadius)
        let rectPath = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: radius)
        fillColor.setFill()
        rectPath.fill()
    }


}
