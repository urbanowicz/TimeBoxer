//
//  StopButton.swift
//  TimeBoxer_v0
//
//  Created by Tomasz Urbanowicz on 04.11.2015.
//  Copyright © 2015 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class StopButton: AbstractRoundButton {

    override func prepareFrontShapePath() -> CGPath {
        let rx:CGFloat = 0.333
        let ry:CGFloat = 0.333
        let x:CGFloat = rx * bounds.width
        let y:CGFloat = ry * bounds.height
        let a:CGFloat = bounds.width - 2*x
        
        let roundedRectPath = UIBezierPath(roundedRect: CGRect(x:x, y:y, width:a, height:a), cornerRadius: 2.5)
        return roundedRectPath.CGPath
    }

}
