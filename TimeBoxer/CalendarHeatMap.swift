//
//  CalendarHeatMap.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 26/07/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class CalendarHeatMap: UIView, UIGestureRecognizerDelegate {
    
    private var currentMonth:MonthHeatMapView?
    
    private var previousWidth:CGFloat = 0.0
    private let panGestureRecognizer = UIPanGestureRecognizer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        doBasicInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        doBasicInit()
    }
    
    private func doBasicInit() {
        let calendar = NSCalendar.currentCalendar()
        let todayComponents = calendar.components(NSCalendarUnit.Year.union(NSCalendarUnit.Month).union(NSCalendarUnit.Day), fromDate: NSDate())
        currentMonth = MonthHeatMapView(year: todayComponents.year, month: todayComponents.month, day: todayComponents.day)
        currentMonth!.backgroundColor = UIColor.redColor()
        addSubview(currentMonth!)
    }

    override func layoutSubviews() {
            currentMonth!.frame = CGRectMake(0, 0, frame.width, frame.height)
            previousWidth = frame.width
            invalidateIntrinsicContentSize()
    }
    override func intrinsicContentSize() -> CGSize {
        return currentMonth!.intrinsicContentSize()
    }
    
    //MARK: Navigation, gesture recognition
    private func setupGestureRecognizer() {
        panGestureRecognizer.addTarget(self, action: #selector(CalendarHeatMap.handleSwipeGesture(_:)))
        panGestureRecognizer.delegate = self
        self.addGestureRecognizer(panGestureRecognizer)
        
    }
    
    func handleSwipeGesture(gestureRecognizer:UIPanGestureRecognizer) {
        //if the user swipes more than the threshold the transition is comitted
        //it is reversed otherwise
        //let threshold = 100
        
        if gestureRecognizer.state == .Began {
            let startY = gestureRecognizer.locationInView(self).y
            print("startY: \(startY)")
        }
        
        if gestureRecognizer.state == .Changed {
            let translation = gestureRecognizer.translationInView(self)
            print("translation: \(translation)")
        }
        
        if gestureRecognizer.state == .Ended {
            let translation = gestureRecognizer.translationInView(self).y
            let endY = gestureRecognizer.locationInView(self).y
            print("translation END: \(translation)")
            print("endY \(endY)")
        }
        

    }
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer != panGestureRecognizer {
            return true
        }
        let translation = panGestureRecognizer.translationInView(self)
        if fabs(translation.x) > fabs(translation.y) {
            return false
        }
        return true
    }
    
}
