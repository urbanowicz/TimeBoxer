//
//  StopButton.swift
//  TimeBoxer_v0
//
//  Created by Tomasz on 04.11.2015.
//  Copyright © 2015 Tomasz. All rights reserved.
//

import UIKit

class StopButton: AbstractOvalButton {

    override func drawFrontLayer(rect: CGRect) {
        let rx:CGFloat = 0.333
        let ry:CGFloat = 0.333
        let x:CGFloat = rx * rect.width
        let y:CGFloat = ry * rect.height
        let a:CGFloat = rect.width - 2*x
        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRect(x:x, y:y,width:a,height:a))
    }

}
