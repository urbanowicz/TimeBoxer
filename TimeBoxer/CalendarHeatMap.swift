//
//  CalendarHeatMap.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 26/07/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class CalendarHeatMap: UIView, UIGestureRecognizerDelegate, POPAnimationDelegate {
    
    var delegate:CalendarHeatMapDelegate?
    
    private let calendar = NSCalendar.gmtCalendar()
    
    var dataSource:CalendarHeatMapDataSource? {
        didSet {
            previousMonth?.dataSource = dataSource
            currentMonth?.dataSource = dataSource
            nextMonth?.dataSource = dataSource
        }
    }
    
    private var currentMonth:MonthHeatMapView?
    private var previousMonth:MonthHeatMapView?
    private var nextMonth:MonthHeatMapView?

    private let panGestureRecognizer = UIPanGestureRecognizer()
    
    private var monthTransitionAnimationCount:Int = 0
    private let monthTransitionUp:Int = 1
    private let monthTransitionDown:Int = -1
    private var monthTransitionDirection:Int = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        doBasicInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        doBasicInit()
    }
    
    private func doBasicInit() {
        
        let today = NSDate()
        //prepare current month view
        currentMonth = MonthHeatMapView(fromDate: today)
        currentMonth!.backgroundColor = UIColor.clearColor()
        addSubview(currentMonth!)
        
        let firstDayOfTheMonth = calendar.firstDayOfMonth(forDate: today)
        //prepare next month view
        let nextMonthDate = calendar.dateByAddingUnit(NSCalendarUnit.Month, value: 1, toDate: firstDayOfTheMonth, options: NSCalendarOptions.MatchStrictly)!
        nextMonth = MonthHeatMapView(fromDate: nextMonthDate)
        nextMonth!.backgroundColor = UIColor.clearColor()
        nextMonth!.alpha = 0.0
        addSubview(nextMonth!)
        
        //prepare previeous month view
        let previousMonthDate = calendar.dateByAddingUnit(NSCalendarUnit.Month, value: -1, toDate: firstDayOfTheMonth, options: NSCalendarOptions.MatchStrictly)!
        previousMonth = MonthHeatMapView(fromDate: previousMonthDate)
        previousMonth!.backgroundColor = UIColor.clearColor()
        previousMonth!.alpha = 0.0
        addSubview(previousMonth!)
        //setup the gesture recognizer
        setupGestureRecognizer()
        
        clipsToBounds = false

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
        let springSpeed = CGFloat(20)
        let springBounciness = CGFloat(0.0)
        
        if gestureRecognizer.state == .Began {
            if delegate != nil {
                delegate!.transitionAnimationStarted()
            }
        }
        
        if gestureRecognizer.state == .Changed {

            let translation = gestureRecognizer.translationInView(self)
            if fabs(translation.y) < threshold {
                currentMonth!.frame.origin.y = translation.y
                currentMonth!.alpha = 1 - fabs(translation.y) / (threshold * 1.1)
            } else {
                //commit the transition
                gestureRecognizer.enabled = false
                
                //Animate the alpha of the current month
                let currentMonthAlphaAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
                currentMonthAlphaAnimation.duration = 0.05
                currentMonthAlphaAnimation.toValue = 0.0
                currentMonthAlphaAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
                currentMonthAlphaAnimation.delegate = self
                currentMonth!.pop_addAnimation(currentMonthAlphaAnimation, forKey: "alpha")
                
                
                if translation.y < 0 {
                    monthTransitionDirection = monthTransitionUp
                    //swipe up
                    
                    //Animate the alpha of the nextMonth
                    let nextMonthAlphaAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
                    nextMonthAlphaAnimation.duration = 0.05
                    nextMonthAlphaAnimation.toValue = 1.0
                    nextMonthAlphaAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
                    nextMonthAlphaAnimation.delegate = self
                    nextMonth!.pop_addAnimation(nextMonthAlphaAnimation, forKey: "alpha")
                    
                    //Animate the position of the nextMonth
                    let nextMonthPositionAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
                    nextMonthPositionAnimation.toValue = nextMonth!.frame.height / 2.0
                    nextMonthPositionAnimation.delegate = self
                    nextMonthPositionAnimation.springSpeed = springSpeed
                    nextMonthPositionAnimation.springBounciness = springBounciness
                    nextMonth!.pop_addAnimation(nextMonthPositionAnimation, forKey: "positionY")
                    
                    //update the current, previous, next month -> happens in pop_animationDidStop

                } else {
                    //swipe down
                    monthTransitionDirection = monthTransitionDown
                    
                    //Animate the alpha of the previousMonth
                    let previousMonthAlphaAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
                    previousMonthAlphaAnimation.duration = 0.05
                    previousMonthAlphaAnimation.toValue = 1.0
                    previousMonthAlphaAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
                    previousMonthAlphaAnimation.delegate = self
                    previousMonth!.pop_addAnimation(previousMonthAlphaAnimation, forKey: "alpha")
                    
                    //Animate the position of prevousMonth
                    let previousMonthPositionAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
                    previousMonthPositionAnimation.springSpeed = springSpeed
                    previousMonthPositionAnimation.springBounciness = springBounciness
                    previousMonthPositionAnimation.toValue = previousMonth!.frame.height / 2.0
                    previousMonthPositionAnimation.delegate = self
                    previousMonth!.pop_addAnimation(previousMonthPositionAnimation, forKey: "positionY")
                    
                    //update the current, previous and next month -> happens in pop_animationDidStop
                }
            }
        }
        
        if gestureRecognizer.state == .Ended {
            let translation = gestureRecognizer.translationInView(self)
            if fabs(translation.y) < threshold {
                let currentMonthAlphaAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
                currentMonthAlphaAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                currentMonthAlphaAnimation.duration = 0.1
                currentMonthAlphaAnimation.toValue = 1.0
                currentMonth!.pop_addAnimation(currentMonthAlphaAnimation, forKey: "alpha")
                
                let currentMonthPositionAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
                currentMonthPositionAnimation.springSpeed = springSpeed
                currentMonthPositionAnimation.springBounciness = 3
                currentMonthPositionAnimation.toValue = currentMonth!.frame.height / 2.0
                currentMonth!.pop_addAnimation(currentMonthPositionAnimation, forKey: "positionY")
            
                if delegate != nil {
                    delegate!.transitionAnimationEnded()
                }
            } else {
                print("GESTURE RECOGNIZER END")
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
    
    func pop_animationDidStop(anim: POPAnimation!, finished: Bool) {
        

        
        monthTransitionAnimationCount += 1
        if monthTransitionAnimationCount == 3 {
            if delegate != nil {
                delegate!.transitionAnimationEnded()
            }
            if monthTransitionDirection == monthTransitionUp {
                //swipe up
                currentMonth!.layer.position = CGPointMake(currentMonth!.layer.position.x, -1.0 * currentMonth!.frame.height / 2.0)
                previousMonth!.removeFromSuperview()
                previousMonth = currentMonth
                currentMonth = nextMonth
                let nextMonthDate  = calendar.firstDayOfMonth(forDate:nextMonth!.currentDate!)
                
                let newNextMonthDate = calendar.dateByAddingUnit(NSCalendarUnit.Month, value: 1, toDate: nextMonthDate, options: NSCalendarOptions.MatchStrictly)!
                nextMonth = MonthHeatMapView(fromDate: newNextMonthDate)
                nextMonth!.backgroundColor = UIColor.clearColor()
                nextMonth!.alpha = 0.0
                nextMonth!.dataSource = dataSource
                addSubview(nextMonth!)
            } else {
                //swipe down
                currentMonth!.layer.position = CGPointMake(currentMonth!.layer.position.x, previousMonth!.frame.height + currentMonth!.frame.height / 2.0)
                nextMonth!.removeFromSuperview()
                nextMonth = currentMonth
                currentMonth = previousMonth
                let previousMonthDate = calendar.firstDayOfMonth(forDate:previousMonth!.currentDate!)
                let newPreviousMonthDate = calendar.dateByAddingUnit(NSCalendarUnit.Month, value: -1, toDate: previousMonthDate, options: NSCalendarOptions.MatchStrictly)!
                previousMonth = MonthHeatMapView(fromDate: newPreviousMonthDate)
                previousMonth!.backgroundColor = UIColor.clearColor()
                previousMonth!.alpha = 0.0
                previousMonth!.dataSource = dataSource
                addSubview(previousMonth!)
            }
            monthTransitionAnimationCount = 0
            panGestureRecognizer.enabled = true
        }
    }
}
