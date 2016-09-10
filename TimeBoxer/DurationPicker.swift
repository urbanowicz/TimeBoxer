//
//  DurationPicker.swift
//  TimeBoxer
//
//  Created by Tomasz on 09/09/16.
//  Copyright © 2016 Tomasz. All rights reserved.
//

import UIKit

class DurationPicker: UIView, UIScrollViewDelegate {
    var scrollView = UIScrollView()
    private var currentDurationSeconds = 5*60 // 5 minutes
    private let maxDurationSeconds = 6*60*60 //8 hours
    private let minutesToTextConverter = MinutesToStringConverter()
    private var durationLabels = [UILabel]()
    private let selectionRect = UIView()
    
    private var numberOfLabels: Int {
        get {
            let maxDurationMinutes = maxDurationSeconds/60
            return maxDurationMinutes / 5
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //setup the scroll view
        scrollView.contentOffset = CGPointMake(0,0)
        scrollView.directionalLockEnabled = true
        scrollView.pagingEnabled = false
        scrollView.bounces = true
        scrollView.scrollEnabled = true
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        addSubview(scrollView)
        
        //setup the selection rect
        selectionRect.backgroundColor = Colors.green().withAlpha(0.1)
        scrollView.addSubview(selectionRect)
        
        //setup the duration labels
        for labelNumber in 1...numberOfLabels {
            let durationLabel = UILabel()
            durationLabel.font = UIFont(name: "Menlo-Regular", size: 18)
            durationLabel.textColor = Colors.silver()
            durationLabel.text = minutesToTextConverter.convert(5*labelNumber)
            durationLabel.sizeToFit()
            durationLabels.append(durationLabel)
            scrollView.addSubview(durationLabel)
        }
    }
    
    override func layoutSubviews() {
        //layout the main view
        layer.mask = prepareMaskingLayerWithRoundedCorners()
        
        //layout the scrollView
        scrollView.frame = bounds
        scrollView.contentSize = CGSizeMake(bounds.width, bounds.height*(CGFloat(numberOfLabels+2) / 3))
        
        //layout the labels
        let dy = bounds.height / 3
        var yOffset = dy / 2
        yOffset -=  durationLabels[0].frame.height/2.0
        yOffset += dy
        let xOffset = CGFloat(10)
        for labelNumber in 1...numberOfLabels {
            let durationLabel = durationLabels[labelNumber-1]
            durationLabel.frame.origin = CGPointMake(xOffset, yOffset)
            yOffset += dy
        }
        
        //layout the selection rect
        selectionRect.frame = CGRectMake(0, dy, bounds.width, dy)

    }
    
    private func prepareMaskingLayerWithRoundedCorners() -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 3.0).CGPath
        return shapeLayer
    }
    
    //Mark: UIScrollViewDelegate 
    func scrollViewDidScroll(scrollView: UIScrollView) {
        selectionRect.transform = CGAffineTransformMakeTranslation(0, scrollView.contentOffset.y)
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let dy = bounds.height / 3.0
        let contentOffset = targetContentOffset.memory.y
        
        let upperContentOffset = ceil(contentOffset / dy) * dy
        let lowerContentOffset = floor(contentOffset / dy) * dy
        if upperContentOffset - contentOffset < contentOffset - lowerContentOffset {
            targetContentOffset.memory.y = upperContentOffset
        } else {
            targetContentOffset.memory.y = lowerContentOffset
        }
    }
}
