//
//  HorizontalBarView.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 18/03/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit


class HorizontalBarView: UIView {
    var fillColor:UIColor = UIColor.redColor()
    var cornerRadius:CGFloat = CGFloat(0.0)
    var value:CGFloat = CGFloat(1.0) //Value between 0.0 and 0.1
    private var innerLabel: UILabel
    private var outerLabel: UILabel
    var labelText: String?
    
    required init(coder aDecoder: NSCoder) {
        innerLabel = UILabel()
        outerLabel = UILabel()
        innerLabel.font = UIFont(name: "Avenir Book", size: 14)
        outerLabel.font = UIFont(name: "Avenir Book", size: 14)
        innerLabel.textColor = Colors.almostBlack()
        outerLabel.textColor = Colors.azure()
        super.init(coder: aDecoder)
        self.addSubview(innerLabel)
        self.addSubview(outerLabel)
        
    }
    
    override func drawRect(rect: CGRect) {
        let rectToDraw = CGRectMake(rect.origin.x, rect.origin.y, value * rect.width, rect.height)
        let path = UIBezierPath(roundedRect: rectToDraw, cornerRadius: cornerRadius)
        fillColor.setFill()
        path.fill()
        
       layoutInnerLabel(rectToDraw)
       layoutOuterLabel(rectToDraw)
    }
    
    private func layoutInnerLabel(rectToDraw: CGRect) {

        if let text = labelText {
            innerLabel.text = text
        }
        innerLabel.sizeToFit()
        innerLabel.frame.origin.x = rectToDraw.width - innerLabel.bounds.width - 5
        innerLabel.frame.origin.y = rectToDraw.height/2.0 - innerLabel.frame.height/2.0
        if innerLabel.bounds.width > rectToDraw.width - 10 {
            innerLabel.hidden = true
        } else {
            innerLabel.hidden = false
        }
        
    }
    
    private func layoutOuterLabel(rectToDraw: CGRect) {

        if let text = labelText {
            outerLabel.text = text
        }
        outerLabel.sizeToFit()
        outerLabel.frame.origin.x = rectToDraw.width + 5
        outerLabel.frame.origin.y = rectToDraw.height/2.0 - outerLabel.frame.height/2.0
        if outerLabel.bounds.width > rectToDraw.width - 10 {
            outerLabel.hidden = false
        } else {
            outerLabel.hidden = true
        }
    }
    
}
