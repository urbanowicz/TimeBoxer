//
//  PauseButton.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 02.11.2015.
//  Copyright © 2015 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class PauseButton: AbstractRoundButton {
    
    override func prepareFrontShapePath() -> CGPath {
        let a = bounds.width
        let rx:CGFloat = 0.3333
        let ry:CGFloat = 0.3333
        let rw:CGFloat = 0.1
        let w = rw*a
        let h = a - 2*ry*a
        
        let x1 = rx * a
        let y1 = ry * a
        let firstRect = CGRect(x:x1, y:y1, width:w, height:h)
        let firstRectPath = UIBezierPath(roundedRect: firstRect, cornerRadius: 3.0)
        
        let x2 = a - x1 - w
        let y2 = y1
        let secondRect = CGRect(x:x2, y:y2, width:w, height: h)
        let secondRectPath = UIBezierPath(roundedRect: secondRect, cornerRadius: 3.0)
        
        let combinedPath = UIBezierPath()
        combinedPath.appendPath(firstRectPath)
        combinedPath.appendPath(secondRectPath)
        
        return combinedPath.CGPath
    }
    
}
