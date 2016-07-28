//
//  CalendarHeatMap.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 26/07/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class CalendarHeatMap: UIView, UIGestureRecognizerDelegate {
    
    var year:Int = 0
    var month:Int = 0
    var day:Int = 0
    
    var currentDateComponents:NSDateComponents {
        get {
            let currentDateComponents = NSDateComponents()
            currentDateComponents.year = year
            currentDateComponents.month = month
            currentDateComponents.day = day
            return currentDateComponents
        }
    }
    
    let sun = UILabel()
    let mon = UILabel()
    let tue = UILabel()
    let wed = UILabel()
    let thu = UILabel()
    let fri = UILabel()
    let sat = UILabel()
    
    private var dayNames = [UILabel]()
    
    let dayNameFont = UIFont(name: "Avenir-Book", size: 12)
    let dayNumberFont = UIFont(name: "Menlo-Regular", size: 12)
    let fontColor = UIColor.whiteColor()
    
    //cellSize is the size of the bounding rectangle inside of which each element of the calendar will fit.
    private var cellSize:CGSize = CGSizeZero
    
    //cDistance variable is key to laying out the elements of the calendar.
    //it is a distance between centers of two consecutive elements in the calendar. Both in y and x direction.
    //eg. S M T W T F S. The distance between the centers of these letters is equal to cDistance.
    private var cDistance:CGFloat = 0.0
    
    private var dayNumbers = [UILabel]()
    
    private let calendar = NSCalendar.currentCalendar()
    
    private var previousBoundsWidth:CGFloat = 0.0
    
    override var bounds:CGRect {
        didSet {
            if bounds.width != previousBoundsWidth {
                computeCellSize() //Cell size could be computed in doBasicInit but it makes sense for me to keep it here
                computeCDistance()
                layoutDayNames()
                layoutDayNumbers()
                invalidateIntrinsicContentSize()
                previousBoundsWidth = bounds.width
            }
        }
    }
    
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
        setupCurrentDate()
        setupDayNames()
        setupDayNumbers()
        setupGestureRecognizer()
    }
    
    //MARK: setting up elements
    private func setupCurrentDate() {
        let todayComponents = calendar.components(NSCalendarUnit.Year.union(NSCalendarUnit.Month).union(NSCalendarUnit.Day), fromDate: NSDate())
        year = todayComponents.year
        month = todayComponents.month
        day = todayComponents.day
    }
    
    private func setupDayNames() {
        //init day names
        func initLabelWithText(text:String, label:UILabel) {
            label.font = dayNameFont
            label.text = text
            label.textColor = fontColor
            label.sizeToFit()
            addSubview(label)
            dayNames.append(label)
        }
        
        initLabelWithText("S", label: sun)
        initLabelWithText("M", label: mon)
        initLabelWithText("T", label: tue)
        initLabelWithText("W", label: wed)
        initLabelWithText("T", label: thu)
        initLabelWithText("F", label: fri)
        initLabelWithText("S", label: sat)
    }
    
    private func setupDayNumbers() {
        func getNumberOfDaysInTheMonth() -> Int {
            let currentDate = calendar.dateFromComponents(currentDateComponents)!
            return calendar.rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: currentDate).length
        }
        
        for dayNumberLabel in dayNumbers {
            dayNumberLabel.removeFromSuperview()
        }
        
        dayNumbers.removeAll(keepCapacity: true)
        for dayNumber in 1...getNumberOfDaysInTheMonth() {
            let dayLabel = UILabel()
            dayLabel.font = dayNumberFont
            dayLabel.textColor = fontColor
            dayLabel.text = String(dayNumber)
            dayLabel.sizeToFit()
            dayNumbers.append(dayLabel)
            addSubview(dayLabel)
        }
    }
    
    //MARK: Compuing key variables
    private func computeCellSize() {
        //find the size of the cell that each symbol in the calendar will take
        let sampleCalendarCell = UILabel()
        sampleCalendarCell.font = dayNumberFont
        sampleCalendarCell.text = "00"
        sampleCalendarCell.sizeToFit()
        cellSize = sampleCalendarCell.frame.size
    }
    
    private func computeCDistance() {
        cDistance = (bounds.width - cellSize.width) / 6.0
    }
    
    //MARK: laying elements out
    override func intrinsicContentSize() -> CGSize {
        if let lastDayNumberLabel = dayNumbers.last {
            let yMax = lastDayNumberLabel.frame.origin.y + lastDayNumberLabel.frame.size.height
            return CGSizeMake(UIViewNoIntrinsicMetric, yMax)
        }
        return CGSizeMake(UIViewNoIntrinsicMetric, sun.frame.height)
    }

    private func layoutDayNames() {
        sun.layer.position = CGPointMake(cellSize.width/2.0, sun.frame.height/2.0)
        mon.layer.position = CGPointMake(sun.layer.position.x + cDistance, sun.layer.position.y)
        tue.layer.position = CGPointMake(mon.layer.position.x + cDistance, sun.layer.position.y)
        wed.layer.position = CGPointMake(tue.layer.position.x + cDistance, sun.layer.position.y)
        thu.layer.position = CGPointMake(wed.layer.position.x + cDistance, sun.layer.position.y)
        fri.layer.position = CGPointMake(thu.layer.position.x + cDistance, sun.layer.position.y)
        sat.layer.position = CGPointMake(fri.layer.position.x + cDistance, sun.layer.position.y)
        
    }
    
    private func layoutDayNumbers() {
        func getLabelForTheFirstDayOfTheMonth() -> UILabel {
            let components = currentDateComponents
            //What day of the week was the first day of the month?
            let firstDayOfTheMonthComponents = NSDateComponents()
            firstDayOfTheMonthComponents.day = 1
            firstDayOfTheMonthComponents.month = components.month
            firstDayOfTheMonthComponents.year = components.year
            let firstDayOfTheMonth = calendar.dateFromComponents(firstDayOfTheMonthComponents)!
            let firstDayOfTheMonthWeekday = calendar.components(NSCalendarUnit.Weekday, fromDate: firstDayOfTheMonth).weekday
            return dayNames[firstDayOfTheMonthWeekday - 1]
            
        }
        
        let firstDayOfTheMonthLabel = getLabelForTheFirstDayOfTheMonth()
        var x = firstDayOfTheMonthLabel.layer.position.x
        var y = firstDayOfTheMonthLabel.layer.position.y + cDistance
        for dayNumberLabel in dayNumbers {
            dayNumberLabel.layer.position = CGPointMake(x,y)
            //advance the position
            if x == sat.layer.position.x {
                x = sun.layer.position.x
                y += cDistance
            } else {
                x += cDistance
            }
        }
    }

    //MARK: Navigation, gesture recognition
    private func setupGestureRecognizer() {
        panGestureRecognizer.addTarget(self, action: #selector(CalendarHeatMap.handleSwipeGesture(_:)))
        panGestureRecognizer.delegate = self
        self.addGestureRecognizer(panGestureRecognizer)
        
    }
    
    func handleSwipeGesture(gestureRecognizer:UISwipeGestureRecognizer) {
        print(gestureRecognizer.locationInView(self))
    }
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        print("CalendarHeatMap.shouldBegin")
        if gestureRecognizer != panGestureRecognizer {
            return true
        }
        let translation = panGestureRecognizer.translationInView(self)
        if fabs(translation.x) > fabs(translation.y) {
            return false
        }
        return true
    }
    
//    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        print("REQUIRED 1")
//        return true
//    }
}
