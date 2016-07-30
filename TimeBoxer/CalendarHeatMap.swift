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
    private var previousMonth:MonthHeatMapView?
    private var nextMonth:MonthHeatMapView?

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
        
        let now = NSDate()
        //prepare current month view
        currentMonth = MonthHeatMapView(fromDate: now)
        currentMonth!.backgroundColor = UIColor.clearColor()
        addSubview(currentMonth!)
        
        //prepare next month view
        let calendar = NSCalendar.currentCalendar()
        let nextMonthDate = calendar.dateByAddingUnit(NSCalendarUnit.Month, value: 1, toDate: now, options: NSCalendarOptions.WrapComponents)!
        nextMonth = MonthHeatMapView(fromDate: nextMonthDate)
        nextMonth!.backgroundColor = UIColor.clearColor()
        nextMonth!.alpha = 0.0
        addSubview(nextMonth!)
        
        //prepare previeous month view
        let previousMonthDate = calendar.dateByAddingUnit(NSCalendarUnit.Month, value: -1, toDate: now, options: NSCalendarOptions.WrapComponents)!
        previousMonth = MonthHeatMapView(fromDate: previousMonthDate)
        previousMonth!.backgroundColor = UIColor.clearColor()
        previousMonth!.alpha = 0.0
        addSubview(previousMonth!)
        //setup the gesture recognizer
        setupGestureRecognizer()
        
        clipsToBounds = true

    }

    override func layoutSubviews() {
        currentMonth!.frame = CGRectMake(0, 0, frame.width, frame.height)
        currentMonth!.heightToFit()
        nextMonth!.frame = CGRectMake(0, frame.height, frame.width, frame.height)
        nextMonth!.heightToFit()
        previousMonth!.frame = CGRectMake(0, -frame.height, frame.width, frame.height)
        previousMonth!.heightToFit()
        previousMonth!.frame.origin = CGPointMake(0, -previousMonth!.frame.height)
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
        let threshold = CGFloat(50)
        
        
        if gestureRecognizer.state == .Changed {
            let translation = gestureRecognizer.translationInView(self)
            if fabs(translation.y) < threshold {
                currentMonth!.frame.origin.y = translation.y
                currentMonth!.alpha = 1 - fabs(translation.y) / (threshold * 1.2)
            } else {
                //commit the transition
                gestureRecognizer.cancel()
                
                //Animate the alpha of the current month
                let currentMonthAlphaAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
                currentMonthAlphaAnimation.duration = 0.2
                currentMonthAlphaAnimation.toValue = 0.0
                currentMonthAlphaAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                currentMonth!.pop_addAnimation(currentMonthAlphaAnimation, forKey: "alpha")
                
                if translation.y < 0 {
                    //swipe up
                    //Animate the position of the current month
                    let currentMonthPositionAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
                    currentMonthPositionAnimation.springSpeed = 20
                    currentMonthPositionAnimation.springBounciness = 3
                    currentMonthPositionAnimation.toValue =  -1.0 * currentMonth!.frame.height / 2.0
                    currentMonth!.pop_addAnimation(currentMonthPositionAnimation, forKey: "positionY")
                    
                    //Animate the alpha of the nextMonth
                    let nextMonthAlphaAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
                    nextMonthAlphaAnimation.duration = 0.2
                    nextMonthAlphaAnimation.toValue = 1.0
                    nextMonthAlphaAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                    nextMonth!.pop_addAnimation(nextMonthAlphaAnimation, forKey: "alpha")
                    
                    //Animate the position of the nextMonth
                    let nextMonthPositionAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
                    nextMonthPositionAnimation.springSpeed = 20
                    nextMonthPositionAnimation.springBounciness = 3
                    nextMonthPositionAnimation.toValue = nextMonth!.frame.height / 2.0
                    nextMonth!.pop_addAnimation(nextMonthPositionAnimation, forKey: "positionY")
                    
                    //update the current, previous, next month
                    previousMonth!.removeFromSuperview()
                    previousMonth = currentMonth
                    previousMonth!.backgroundColor = UIColor.clearColor()
                    currentMonth = nextMonth
                    currentMonth!.backgroundColor = UIColor.clearColor()
                    let nextMonthDate  = NSCalendar.currentCalendar().dateFromComponents(nextMonth!.currentDateComponents)!
                    let newNextMonthDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Month, value: 1, toDate: nextMonthDate, options: NSCalendarOptions.WrapComponents)!
                    nextMonth = MonthHeatMapView(fromDate: newNextMonthDate)
                    nextMonth!.backgroundColor = UIColor.clearColor()
                    nextMonth!.alpha = 0.0
                    addSubview(nextMonth!)
                } else {
                    //swipe down
                    //Animate the position of the current month
                    let currentMonthPositionAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
                    currentMonthPositionAnimation.springSpeed = 20
                    currentMonthPositionAnimation.springBounciness = 3
                    currentMonthPositionAnimation.toValue =  previousMonth!.frame.height + currentMonth!.frame.height / 2.0
                    currentMonth!.pop_addAnimation(currentMonthPositionAnimation, forKey: "positionY")
                    
                    //Animate the alpha of the previousMonth
                    let previousMonthAlphaAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
                    previousMonthAlphaAnimation.duration = 0.2
                    previousMonthAlphaAnimation.toValue = 1.0
                    previousMonthAlphaAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                    previousMonth!.pop_addAnimation(previousMonthAlphaAnimation, forKey: "alpha")
                    
                    //Animate the position of prevousMonth
                    let previousMonthPositionAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
                    previousMonthPositionAnimation.springSpeed = 20
                    previousMonthPositionAnimation.springBounciness = 3
                    previousMonthPositionAnimation.toValue = previousMonth!.frame.height / 2.0
                    previousMonth!.pop_addAnimation(previousMonthPositionAnimation, forKey: "positionY")
                    
                    //update the current, previous and next month
                    nextMonth!.removeFromSuperview()
                    nextMonth = currentMonth
                    nextMonth!.backgroundColor = UIColor.clearColor()
                    currentMonth = previousMonth
                    currentMonth!.backgroundColor = UIColor.clearColor()
                    
                    let previousMonthDate = NSCalendar.currentCalendar().dateFromComponents(previousMonth!.currentDateComponents)!
                    let newPreviousMonthDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Month, value: -1, toDate: previousMonthDate, options: NSCalendarOptions.WrapComponents)!
                    previousMonth = MonthHeatMapView(fromDate: newPreviousMonthDate)
                    previousMonth!.backgroundColor = UIColor.clearColor()
                    previousMonth!.alpha = 0.0
                    addSubview(previousMonth!)
                }
            }
        }
        
        if gestureRecognizer.state == .Ended {
            let translation = gestureRecognizer.translationInView(self)
            if fabs(translation.y) < threshold {
                let currentMonthAlphaAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
                currentMonthAlphaAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                currentMonthAlphaAnimation.duration = 0.2
                currentMonthAlphaAnimation.toValue = 1.0
                currentMonth!.pop_addAnimation(currentMonthAlphaAnimation, forKey: "alpha")
                
                let currentMonthPositionAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
                currentMonthPositionAnimation.springSpeed = 20
                currentMonthPositionAnimation.springBounciness = 3
                currentMonthPositionAnimation.toValue = currentMonth!.frame.height / 2.0
                currentMonth!.pop_addAnimation(currentMonthPositionAnimation, forKey: "positionY")
                
            } else {
                //commit the transition
            }
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
