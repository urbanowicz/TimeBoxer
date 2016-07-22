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
    let frontLayer = CAShapeLayer()
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
    var frontLayerColor = UIColor.whiteColor() {
        didSet {
            frontLayer.fillColor = frontLayerColor.CGColor
        }
    }
    var roundLayerColor = UIColor.whiteColor() {
        didSet {
            let shapeLayer = layer as! CAShapeLayer
            shapeLayer.fillColor = roundLayerColor.CGColor
        }
    }
    
    var radius:CGFloat {
        get {
            return bounds.width/2.0
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
        
        //setup the round background layer
        layer.backgroundColor = UIColor.clearColor().CGColor
        
        //setup the layer that will draw the border around the button
        borderLayer.backgroundColor = UIColor.clearColor().CGColor
        borderLayer.fillColor = UIColor.clearColor().CGColor
        layer.addSublayer(borderLayer)
        
        //setup the layer that will draw the front shape
        frontLayer.backgroundColor = UIColor.clearColor().CGColor
        frontLayer.strokeColor = UIColor.clearColor().CGColor
        layer.addSublayer(frontLayer)
    }
    
    override func layoutSubviews() {
        //Draw the background circle
        let shapeLayer = layer as! CAShapeLayer
        shapeLayer.path = UIBezierPath(ovalInRect: shapeLayer.bounds).CGPath
        
        //Draw the border
        borderLayer.frame = CGRectMake(0.0, 0.0, layer.frame.width, layer.frame.height)
        borderLayer.path = UIBezierPath(ovalInRect:borderLayer.bounds).CGPath
        
        //Draw the front shape
        frontLayer.frame = CGRectMake(0.0, 0.0, layer.frame.width , layer.frame.height)
        frontLayer.path = prepareFrontShapePath()
        
    }
    
    override class func layerClass() -> AnyClass {
        return CAShapeLayer.self
    }
    func prepareFrontShapePath() -> CGPath {
        //implement in subclasses to return custom shapes
        fatalError("This is an abstract method, please write a concrete implementation it in your subclass")

    }
}
