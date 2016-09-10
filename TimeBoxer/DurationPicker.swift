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
    private var minDurationSeconds = 5*60 // 5 minutes
    private let maxDurationSeconds = 6*60*60 //6 hours
    private let minutesToTextConverter = MinutesToStringConverter()
    private var durationLabels = [UILabel]()
    private let selectionRect = UIView()
    
    private var numberOfLabels: Int {
        get {
            let maxDurationMinutes = maxDurationSeconds/60
            return maxDurationMinutes / 5
        }
    }
    
    var duration: Int {
        let dy = bounds.height / 3.0
        let rowNumber = Int(round(scrollView.contentOffset.y / dy))
        if rowNumber < 0 {
            return minDurationSeconds
        }
        if rowNumber >= durationLabels.count {
            return maxDurationSeconds
        }
        
        return (rowNumber+1) * minDurationSeconds
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
            durationLabel.textColor = Colors.silver().withAlpha(0.3)
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
            if labelNumber <= 2 {
                updateAlphaForLabel(durationLabel)
            }
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
    
    private func updateAlphaForLabel(label:UILabel) {
        let dy = bounds.height / 3
        let middleY = scrollView.contentOffset.y + dy + dy/2.0
        let distanceFromTopToMiddle = dy + dy/2.0
        let howFarOffCenter = min(fabs(label.layer.position.y - middleY), distanceFromTopToMiddle)
        let alpha = max(1 - CGFloat(howFarOffCenter)/distanceFromTopToMiddle, 0.05)
        label.textColor = Colors.silver().withAlpha(alpha)
    }
    
    //Mark: UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //Make sure the selection rect stays in place
        selectionRect.transform = CGAffineTransformMakeTranslation(0, scrollView.contentOffset.y)
        
        //find labels that are being displayed
        let dy = bounds.height / 3
        let firstVisibleRowNumber = Int(floor(scrollView.contentOffset.y / dy)) - 1
        
        for i in 0...3 {
            if firstVisibleRowNumber + i < 0 {
                continue
            }
            
            if firstVisibleRowNumber + i >= durationLabels.count {
                break
            }
            
            let label = durationLabels[firstVisibleRowNumber + i]
            updateAlphaForLabel(label)
        }

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
