//
//  LeftDrawerView.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 13/06/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class LeftDrawerView: UIView {
    var fillColor = UIColor.whiteColor()
    
   override func drawRect(rect: CGRect) {
        var innerRect = CGRectZero
        innerRect.size.width = rect.width - 2.0/7.0 * rect.width
        innerRect.size.height = rect.height - 2.0/3.0 * rect.height
        innerRect.origin.x = rect.origin.x + 1.0/7.0 * rect.width
        innerRect.origin.y = rect.origin.y + 1.0/3.0 * rect.height
        doDraw(innerRect)
    }
    
    func doDraw(rect: CGRect) {
        var r1 = CGRectZero
        var r2 = CGRectZero
        var r3 = CGRectZero
        let ratio = CGFloat(1.0/5.0)
        
        r1.size.width = ratio * rect.width
        r2.size.width = r1.width
        r3.size.width = r2.width
        
        r1.size.height = 1.0/3.0 * rect.height
        r2.size.height = 2.0/3.0 * rect.height
        r3.size.height = rect.height
        
        r1.origin.x = rect.origin.x
        r2.origin.x = rect.origin.x + r1.width + ratio * rect.width
        r3.origin.x = rect.origin.x + rect.width - r3.width
        
        r1.origin.y = rect.origin.y + rect.height - r1.height
        r2.origin.y = rect.origin.y + rect.height - r2.height
        r3.origin.y = rect.origin.y + rect.height - r3.height
        
        let path1 = UIBezierPath(roundedRect: r1, cornerRadius: 2.0)
        let path2 = UIBezierPath(roundedRect: r2, cornerRadius: 2.0)
        let path3 = UIBezierPath(roundedRect: r3, cornerRadius: 2.0)
        
        fillColor.setFill()
        path1.fill()
        path2.fill()
        path3.fill()
    }
 

}
