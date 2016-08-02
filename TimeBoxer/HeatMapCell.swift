//
//  HeatMapCell.swift
//  TimeBoxer
//
//  Created by Tomasz on 02/08/16.
//  Copyright © 2016 Tomasz. All rights reserved.
//

import UIKit

class HeatMapCell: UIView {

    let dayNumberLabel:UILabel = UILabel()
    
    private let circleLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        doBasicInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        doBasicInit()
    }
    
    private func doBasicInit() {
        circleLayer.fillColor = UIColor.brownColor().CGColor
        circleLayer.backgroundColor = UIColor.clearColor().CGColor
        layer.addSublayer(circleLayer)
        addSubview(dayNumberLabel)
    }
    
    private func prepareCircleLayerPath() -> CGPath {
        let smallerRect = CGRectMake(0.15 * bounds.width, 0.15 * bounds.height, 0.7 * bounds.width, 0.7 * bounds.height)
        let circlePath = UIBezierPath(ovalInRect: smallerRect)
        return circlePath.CGPath
    }
    
    override func layoutSubviews() {
        circleLayer.path = prepareCircleLayerPath()
        dayNumberLabel.layer.position.x = frame.width / 2.0
        dayNumberLabel.layer.position.y = frame.height / 2.0
    }
    
    func getDayNumber() -> Int? {
        return Int(dayNumberLabel.text!)
    }

}
