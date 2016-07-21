//
//  AbstractRoundButton.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 21/07/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class AbstractRoundButton: UIControl {
    let borderLayer = CAShapeLayer()
    var borderWidth = CGFloat(0.0) {
        didSet {
            borderLayer.lineWidth = borderWidth
        }
    }
    var borderColor = UIColor.whiteColor() {
        didSet {
            borderLayer.strokeColor = borderColor.CGColor
        }
    }
    var frontLayerColor = UIColor.whiteColor()
    var roundLayerColor = UIColor.whiteColor() {
        didSet {
            let shapeLayer = layer as! CAShapeLayer
            shapeLayer.fillColor = roundLayerColor.CGColor
        }
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        doBasicInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        doBasicInit()
    }
    
    private func doBasicInit() {
        layer.backgroundColor = UIColor.clearColor().CGColor
        borderLayer.backgroundColor = UIColor.clearColor().CGColor
        borderLayer.fillColor = UIColor.clearColor().CGColor
        layer.addSublayer(borderLayer)
    }
    
    override func layoutSubviews() {
        //Draw the background circle
        let shapeLayer = layer as! CAShapeLayer
        shapeLayer.path = UIBezierPath(ovalInRect: shapeLayer.bounds).CGPath
        
        //Draw the border
        borderLayer.frame = CGRectMake(0.0, 0.0, shapeLayer.frame.width, shapeLayer.frame.height)
        borderLayer.path = UIBezierPath(ovalInRect:borderLayer.bounds).CGPath
    }
    
    override class func layerClass() -> AnyClass {
        return CAShapeLayer.self
    }
}
