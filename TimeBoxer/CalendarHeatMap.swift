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
    
    var leftMargin:CGFloat {
        get {
            return currentMonth!.leftMargin
        }
    }

    private let panGestureRecognizer = UIPanGestureRecognizer()
    
    private let monthTransitionUp:Int = 1
    private let monthTransitionDown:Int = -1
    private var monthTransitionDirection:Int = 1
    
    private var transitionInProgress = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        doBasicInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        doBasicInit()
    }
    
    private func doBasicInit() {
        func dayMonthYear(fromDate: NSDate, withTimeZone:NSTimeZone) -> NSDateComponents {
            let calendar = NSCalendar.currentCalendar()
            calendar.timeZone = withTimeZone
            let comps = calendar.components(NSCalendarUnit.Day.union(NSCalendarUnit.Month).union(NSCalendarUnit.Year).union(.Hour), fromDate: fromDate)
            return comps
        }
        
        let localCalendar = NSCalendar.currentCalendar()
        let todayComps = dayMonthYear(NSDate(), withTimeZone: localCalendar.timeZone)
        let firstDayOfTheMonthComps = NSDateComponents()
        firstDayOfTheMonthComps.year = todayComps.year
        firstDayOfTheMonthComps.month = todayComps.month
        firstDayOfTheMonthComps.day = 1
        let firstDayOfTheMonth = localCalendar.dateFromComponents(firstDayOfTheMonthComps)!
        let firstDayOfNextMonth = localCalendar.dateByAddingUnit(NSCalendarUnit.Month, value:1, toDate: firstDayOfTheMonth, options: .MatchStrictly)!
        let nextMonthComps = dayMonthYear(firstDayOfNextMonth, withTimeZone: localCalendar.timeZone)
        let firstDayOfPreviousMonth = localCalendar.dateByAddingUnit(NSCalendarUnit.Month, value: -1, toDate: firstDayOfTheMonth, options: .MatchStrictly)!
        let previousMonthComps = dayMonthYear(firstDayOfPreviousMonth, withTimeZone: localCalendar.timeZone)
        
        
        //prepare current month view
        currentMonth = MonthHeatMapView(year: todayComps.year, month: todayComps.month, day: todayComps.day)
        currentMonth!.backgroundColor = UIColor.clearColor()
        addSubview(currentMonth!)
        
        //prepare next month view
        nextMonth = MonthHeatMapView(year:nextMonthComps.year, month: nextMonthComps.month, day: nextMonthComps.day)
        nextMonth!.backgroundColor = UIColor.clearColor()
        nextMonth!.alpha = 0.0
        addSubview(nextMonth!)
        
        //prepare previeous month view
        previousMonth = MonthHeatMapView(year:previousMonthComps.year, month: previousMonthComps.month, day: previousMonthComps.day)
        previousMonth!.backgroundColor = UIColor.clearColor()
        previousMonth!.alpha = 0.0
        addSubview(previousMonth!)
        //setup the gesture recognizer
        setupGestureRecognizer()
        
        clipsToBounds = false

    }

    override func layoutSubviews() {
        let screenSize = UIScreen.mainScreen().bounds.size
        currentMonth!.frame = CGRectMake(0, 0, frame.width, frame.height)
        currentMonth!.heightToFit()
        nextMonth!.frame = CGRectMake(0, screenSize.height, frame.width, frame.height)
        nextMonth!.heightToFit()
        previousMonth!.frame = CGRectMake(0, 0, frame.width, frame.height)
        previousMonth!.heightToFit()
        previousMonth!.frame.origin = CGPointMake(0, -previousMonth!.frame.height - frame.origin.y)
        invalidateIntrinsicContentSize()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        superview?.setNeedsUpdateConstraints()
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
        let springSpeed = CGFloat(5)
        let springBounciness = CGFloat(3.0)
        
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
                transitionInProgress = true
                gestureRecognizer.cancel()
                //Animate the alpha of the current month
                let currentMonthAlphaAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
                currentMonthAlphaAnimation.duration = 0.05
                currentMonthAlphaAnimation.toValue = 0.0
                currentMonthAlphaAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
                currentMonth!.pop_addAnimation(currentMonthAlphaAnimation, forKey: "alpha")
                
                
                if translation.y < 0 {
                    monthTransitionDirection = monthTransitionUp
                    //swipe up
                    
                    //Animate the alpha of the nextMonth
                    let nextMonthAlphaAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
                    nextMonthAlphaAnimation.duration = 0.05
                    nextMonthAlphaAnimation.toValue = 1.0
                    nextMonthAlphaAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
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
                //commit the transition
            }
        }
    }
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer != panGestureRecognizer {
            return true
        }
        
        if transitionInProgress {
            //stop animations
            currentMonth!.pop_removeAnimationForKey("alpha")
            if monthTransitionDirection == monthTransitionUp {
                nextMonth!.pop_removeAnimationForKey("alpha")
                nextMonth!.pop_removeAnimationForKey("positionY")
            } else {
                previousMonth!.pop_removeAnimationForKey("alpha")
                previousMonth!.pop_removeAnimationForKey("positionY")
            }
            updateViewsAfterTransition()
            return true
        }
        
        let translation = panGestureRecognizer.translationInView(self)
        if fabs(translation.x) > fabs(translation.y) {
            return false
        }
        return true
    }
    
    
    
    func pop_animationDidStop(anim: POPAnimation!, finished: Bool) {
        if finished == true {
            updateViewsAfterTransition()
            if delegate != nil {
                delegate!.transitionAnimationEnded()
            }
        }
    }
    
    private func updateViewsAfterTransition() {
        if monthTransitionDirection == monthTransitionUp {
            //swipe up
            previousMonth!.removeFromSuperview()
            previousMonth = currentMonth
            currentMonth = nextMonth
            let currentMonthComps = currentMonth!.currentDateComponents
            currentMonthComps.day = 1
            let firstDayOfCurrentMonth = NSCalendar.currentCalendar().dateFromComponents(currentMonthComps)!
            let firstDayOfNextMonth = NSCalendar.currentCalendar().dateByAddingUnit(.Month, value: 1, toDate: firstDayOfCurrentMonth, options: .MatchStrictly)!
            let nextMonthComps = NSCalendar.currentCalendar().components(NSCalendarUnit.Year.union(.Month).union(.Day), fromDate: firstDayOfNextMonth)
            nextMonth = MonthHeatMapView(year: nextMonthComps.year, month: nextMonthComps.month, day: nextMonthComps.day)
            nextMonth!.backgroundColor = UIColor.clearColor()
            nextMonth!.alpha = 0.0
            nextMonth!.dataSource = dataSource
            addSubview(nextMonth!)
        } else {
            //swipe down
            nextMonth!.removeFromSuperview()
            nextMonth = currentMonth
            currentMonth = previousMonth
            let currentMonthComps = currentMonth!.currentDateComponents
            currentMonthComps.day = 1
            let firstDayOfCurrentMonth = NSCalendar.currentCalendar().dateFromComponents(currentMonthComps)!
            let firstDayOfPreviousMonth = NSCalendar.currentCalendar().dateByAddingUnit(.Month, value: -1, toDate: firstDayOfCurrentMonth, options: .MatchStrictly)!
            let previousMonthComps = NSCalendar.currentCalendar().components(NSCalendarUnit.Year.union(.Month).union(.Day), fromDate: firstDayOfPreviousMonth)
            previousMonth = MonthHeatMapView(year: previousMonthComps.year, month: previousMonthComps.month, day: previousMonthComps.day)
            previousMonth!.backgroundColor = UIColor.clearColor()
            previousMonth!.alpha = 0.0
            previousMonth!.dataSource = dataSource
            addSubview(previousMonth!)
        }
        transitionInProgress = false
    }
}
