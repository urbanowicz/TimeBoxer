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
    private var currentDurationSeconds = 5*60
    private let maxDurationSeconds = 6*60*60 //8 hours
    private let minutesToTextConverter = MinutesToStringConverter()
    private var durationLabels = [UILabel]()
    
    private var totalPages: Int {
        get {
            let maxDurationMinutes = maxDurationSeconds/60
            return maxDurationMinutes/5
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //setup the scroll view
        scrollView.contentOffset = CGPointMake(0,0)
        scrollView.directionalLockEnabled = true
        scrollView.pagingEnabled = true
        scrollView.bounces = true
        scrollView.scrollEnabled = true
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        addSubview(scrollView)
        
        //setup the duration labels
        for pageNumber in 1...totalPages {
            let durationLabel = UILabel()
            durationLabel.font = UIFont(name: "Menlo-Regular", size: 18)
            durationLabel.textColor = Colors.silver()
            durationLabel.text = minutesToTextConverter.convert(5*pageNumber)
            durationLabel.sizeToFit()
            durationLabels.append(durationLabel)
            scrollView.addSubview(durationLabel)
        }
        
    }
    
    override func layoutSubviews() {
        scrollView.frame = bounds
        scrollView.contentSize = CGSizeMake(CGFloat(totalPages)*bounds.width, bounds.height)
        for pageNumber in 1...totalPages {
            let durationLabel = durationLabels[pageNumber-1]
            let xOffset = CGFloat(pageNumber - 1) * frame.width
            let w = frame.width
            let h = frame.height
            durationLabel.frame.origin = CGPointMake((w/2.0 - durationLabel.frame.width/2.0) + xOffset, h/2.0 - durationLabel.frame.height/2.0)

        }
    }
}
