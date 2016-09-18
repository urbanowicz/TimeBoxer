//
//  DurationPicker.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 09/09/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class DurationPicker: UIView, UIScrollViewDelegate {
    
    var delegate:DurationPickerDelegate?
    
    var scrollView = UIScrollView()
    private var minDurationSeconds = 5*60 // 5 minutes
    private let maxDurationSeconds = 6*60*60 //6 hours
    private let minutesToTextConverter = MinutesToStringConverter()
    private var durationLabels = [UILabel]()
    private let selectionRect = UIView()
    private var swipeUpIndicator:CAShapeLayer!
    private var swipeDownIndicator:CAShapeLayer!
    
    private var numberOfLabels: Int {
        get {
            let maxDurationMinutes = maxDurationSeconds/60
            return maxDurationMinutes / 5
        }
    }
    
    var durationSeconds: Int {
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
        
        //setup the swipe up indicator
        swipeUpIndicator = prepareSwipeIndicator()
        swipeUpIndicator.fillColor = Colors.green().withAlpha(0.1).CGColor
        swipeUpIndicator.backgroundColor = UIColor.clearColor().CGColor
        scrollView.layer.addSublayer(swipeUpIndicator)
        
        //setup the swipe down indicator
        swipeDownIndicator = prepareSwipeIndicator()
        swipeDownIndicator.fillColor = Colors.green().withAlpha(0.5).CGColor
        swipeDownIndicator.backgroundColor = swipeUpIndicator.backgroundColor
        scrollView.layer.addSublayer(swipeDownIndicator)
        
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
       
        //layout the swipe up indicator
        swipeUpIndicator.transform = CATransform3DIdentity
        swipeUpIndicator.frame.origin = CGPointMake(bounds.width - (xOffset + swipeUpIndicator.frame.width), dy/2 - swipeUpIndicator.frame.height/2)
        swipeUpIndicator.transform = CATransform3DMakeRotation(135.0 * CGFloat(M_PI) / 180.0, 0.0, 0.0, 1.0)
        
        //layout the swipe down indicator
        swipeDownIndicator.transform = CATransform3DIdentity
        swipeDownIndicator.frame.origin = CGPointMake(bounds.width - (xOffset + swipeDownIndicator.frame.width), bounds.height - dy/2 - swipeDownIndicator.frame.height/2)
        swipeDownIndicator.transform = CATransform3DMakeRotation(-45 * CGFloat(M_PI) / 180.0, 0.0, 0.0, 1.0)
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
        let translation = CATransform3DMakeTranslation(0, scrollView.contentOffset.y, 0)
        var rotation = CATransform3DMakeRotation(135.0 * CGFloat(M_PI) / 180.0, 0.0, 0.0, 1.0)
        CATransaction.setDisableActions(true)
        swipeUpIndicator.transform = CATransform3DConcat(rotation, translation)
        rotation = CATransform3DMakeRotation(-45 * CGFloat(M_PI) / 180.0, 0.0, 0.0, 1.0)
        swipeDownIndicator.transform = CATransform3DConcat(rotation, translation)
        CATransaction.setDisableActions(false)
        
        let currentDuration = durationSeconds
        if currentDuration == minDurationSeconds {
            swipeUpIndicator.fillColor = Colors.green().withAlpha(0.1).CGColor
        } else {
            swipeUpIndicator.fillColor = Colors.green().withAlpha(0.5).CGColor
        }
        
        if currentDuration == maxDurationSeconds {
            swipeDownIndicator.fillColor = Colors.green().withAlpha(0.1).CGColor
        } else {
            swipeDownIndicator.fillColor = Colors.green().withAlpha(0.5).CGColor
        }
        
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
    
    func scrollingEnded() {
        delegate?.durationPickerDidChangeValue(self)
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.scrollingEnded()
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.scrollingEnded()
    }
    
    //Mark: helper functions
    private func prepareSwipeIndicator() -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        let w = CGFloat(15)
        let h = CGFloat(15)
        shapeLayer.frame = CGRect(x: 0, y: 0, width: w, height: h)
        let dx = CGFloat(4)
        let path:CGMutablePathRef = CGPathCreateMutable()
        goto(path, p(0, h))
        arc(path, p(w, h), p(w,h - dx/2.0))
        arc(path, p(w, h - dx), p(dx, h - dx))
        line(path, p(dx, h - dx))
        arc(path, p(dx, 0), p(dx/2.0, 0))
        arc(path, p(0,0), p(0, h))
        CGPathCloseSubpath(path)
        shapeLayer.path = path
        return shapeLayer
    }
    
    //These methods were taken from the BackButton.swift
    private func arc(path:CGMutablePathRef, _ p1:CGPoint, _ p2:CGPoint) {
        let radius = CGFloat(1.5)
        CGPathAddArcToPoint(path, nil, p1.x, p1.y, p2.x, p2.y, radius)
    }
    
    private func goto(path:CGMutablePathRef, _ p:CGPoint) {
        CGPathMoveToPoint(path, nil, p.x, p.y)
    }
    
    private func line(path:CGMutablePathRef, _ p:CGPoint) {
        CGPathAddLineToPoint(path, nil, p.x, p.y)
    }
    
    private func p(x:CGFloat, _ y:CGFloat) -> CGPoint {
        return CGPointMake(x, y)
    }
}
