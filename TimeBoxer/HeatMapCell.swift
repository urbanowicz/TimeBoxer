//
//  HeatMapCell.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 02/08/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class HeatMapCell: UIView {

    let dayNumberLabel:UILabel = UILabel()
    
    //heat is a value between 0.0 and 1.0
    var heat = CGFloat(0) {
        didSet {
            if heat == 0 {
                heatLayer.fillColor = Colors.red().CGColor
            } else {
                heatLayer.fillColor = Colors.green().withAlpha(heat).CGColor
            }
        }
    }
    
    private let heatLayer = CAShapeLayer()
    private let selectionLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        doBasicInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        doBasicInit()
    }
    
    private func doBasicInit() {
        setupSelectionLayer()
        setupHeatLayer()
        addSubview(dayNumberLabel)
    }
    
    private func setupSelectionLayer() {
        selectionLayer.fillColor = UIColor.clearColor().CGColor
        selectionLayer.strokeColor = UIColor.whiteColor().CGColor
        selectionLayer.lineWidth = 1.0
        selectionLayer.opacity = 0.0
        layer.addSublayer(selectionLayer)
    }
    
    private func setupHeatLayer() {
        if heat == 0 {
            heatLayer.fillColor = Colors.red().CGColor
        } else {
            heatLayer.fillColor = Colors.green().withAlpha(heat).CGColor
        }
        heatLayer.backgroundColor = UIColor.clearColor().CGColor
        layer.addSublayer(heatLayer)
    }
    
    private func prepareHeatLayerPath() -> CGPath {
        let smallerRect = CGRectMake(0.15 * bounds.width, 0.15 * bounds.height, 0.7 * bounds.width, 0.7 * bounds.height)
        let circlePath = UIBezierPath(ovalInRect: smallerRect)
        return circlePath.CGPath
    }
    
    private func prepareSelectionLayerPath() -> CGPath {
        let scaleFactor = CGFloat(0.8)
        let smallerRect = CGRectMake(((1 - scaleFactor) / 2.0) * bounds.width , ((1 - scaleFactor) / 2.0) * bounds.height, scaleFactor * bounds.width, scaleFactor * bounds.height)
        let selectionPath = UIBezierPath(ovalInRect: smallerRect)
        return selectionPath.CGPath
    }
    
    override func layoutSubviews() {
        selectionLayer.path = prepareSelectionLayerPath()
        heatLayer.path = prepareHeatLayerPath()
        dayNumberLabel.layer.position.x = frame.width / 2.0
        dayNumberLabel.layer.position.y = frame.height / 2.0
    }
    
    func getDayNumber() -> Int? {
        return Int(dayNumberLabel.text!)
    }
    
    func select() {
        selectionLayer.opacity = 1.0
    }
    
    func deselect() {
        selectionLayer.opacity = 0.0
    }

}
