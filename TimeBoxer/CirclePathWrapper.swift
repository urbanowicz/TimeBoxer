//
//  CirclePathWrapper.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 21.12.2015.
//  Copyright © 2015 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

struct CirclePathWrapper {
    let path:CGPath
    
    init(centerX:CGFloat, centerY:CGFloat, radius:CGFloat)
    {
        let rect = CGRect(x:centerX - radius, y:centerY - radius, width: 2*radius, height: 2*radius)
        path = UIBezierPath(ovalInRect: rect).CGPath
    }
}
