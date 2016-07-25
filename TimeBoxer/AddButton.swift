//
//  AddButton.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 10.01.2016.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class AddButton: AbstractRoundButton {
    var cornerRadius = CGFloat(6.0)
    
    override func prepareFrontShapePath() -> CGPath {
        let verticalBar = createVerticalBar(bounds)
        let horizontalBar = createHorizontalBar(bounds)
        let combinedPath = UIBezierPath()
        combinedPath.appendPath(verticalBar)
        combinedPath.appendPath(horizontalBar)
        return combinedPath.CGPath
    }
    
    private func createVerticalBar(rect: CGRect) -> UIBezierPath  {
        let barWidth:CGFloat = rect.width * 0.1
        let barHeight:CGFloat = rect.height * 0.45
        let barX:CGFloat = ((rect.origin.x + rect.width) / 2.0) - (barWidth / 2.0)
        let barY:CGFloat = rect.origin.y + (rect.height - barHeight) / 2.0
        let barRect = CGRect(x:barX, y:barY, width:barWidth, height:barHeight)
        return UIBezierPath(roundedRect: barRect, cornerRadius: cornerRadius)
    }
    
    private func createHorizontalBar(rect: CGRect) -> UIBezierPath {
        let barWidth:CGFloat = rect.width * 0.45
        let barHeight:CGFloat = rect.height * 0.1
        let barX:CGFloat = ((rect.origin.x + rect.width) / 2.0) - (barWidth / 2.0)
        let barY:CGFloat = rect.origin.y + (rect.height - barHeight) / 2.0
        let barRect = CGRect(x:barX, y:barY, width:barWidth, height:barHeight)
        return UIBezierPath(roundedRect: barRect, cornerRadius: cornerRadius)
    }

}
