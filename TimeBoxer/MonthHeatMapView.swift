//
//  MonthHeatMapView.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 29/07/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class MonthHeatMapView: UIView, UIGestureRecognizerDelegate {

    private var year:Int = 0
    private var month:Int = 0
    private var day:Int = 0
    
    var currentDateComponents:NSDateComponents {
        get {
            let currentDateComponents = NSDateComponents()
            currentDateComponents.year = year
            currentDateComponents.month = month
            currentDateComponents.day = day
            return currentDateComponents
        }
    }
    
    var currentDate:NSDate? {
        get {
            return NSCalendar.currentCalendar().dateFromComponents(currentDateComponents)
        }
    }
    
    let monthNameLabel = UILabel()
    let yearLabel = UILabel()
    
    let sun = UILabel()
    let mon = UILabel()
    let tue = UILabel()
    let wed = UILabel()
    let thu = UILabel()
    let fri = UILabel()
    let sat = UILabel()
    
    private var dayNames = [UILabel]()
    
    private var dayNumbers = [HeatMapCell]()
    
    let currentDateLabel = UILabel()
    
    let hoursWorkedLabel = UILabel()
    
    let monthNameFont = UIFont(name:"Avenir-Heavy", size: 22)
    let yearFont = UIFont(name: "Menlo-Regular", size: 12)
    let dayNameFont = UIFont(name: "Avenir-Book", size: 12)
    let dayNumberFont = UIFont(name: "Menlo-Regular", size: 12)
    let currentDateFont = UIFont(name: "Avenir-Medium", size: 14)
    let hoursWorkedFont = UIFont(name: "Avenir-Heavy", size: 18)
    let fontColor = UIColor.whiteColor()
    
    //cellSize is the size of the bounding rectangle inside of which each element of the calendar will fit.
    private var cellSize:CGSize = CGSizeZero
    
    //cDistance variable is key to laying out the elements of the calendar.
    //it is a distance between centers of two consecutive elements in the calendar. Both in y and x direction.
    //eg. S M T W T F S. The distance between the centers of these letters is equal to cDistance.
    private var cDistance:CGFloat = 0.0
    
    //yOffset is used for laying out elements along the y axis. Eg. After the name of the month had been laid out
    //the yOoffset i set to where the next element should be positioned on the y axis.
    private var yOffset:CGFloat = 0.0
    
    private let calendar = NSCalendar.currentCalendar()
    
    private var previousWidth:CGFloat = 0.0
    
    private let tapGestureRecognizer:UITapGestureRecognizer = UITapGestureRecognizer()
    
    convenience init(year:Int, month:Int, day:Int) {
        self.init(frame: CGRectZero)
        self.year = year
        self.month = month
        self.day = day
        doBasicInit()
    }
    
    convenience init(fromComponents components:NSDateComponents) {
        self.init(year: components.year, month: components.month, day: components.day)
    }
    
    convenience init(fromDate date:NSDate) {
        let calendar = NSCalendar.currentCalendar()
        self.init(fromComponents: calendar.components(NSCalendarUnit.Year.union(NSCalendarUnit.Month).union(NSCalendarUnit.Day), fromDate: date))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func doBasicInit() {
        setupCurrentDate()
        setupMonthNameLabel()
        setupYearLabel()
        setupDayNames()
        setupDayNumbers()
        setupCurrentDateLabel()
        setupHoursWorkedLabel()
        setupTapGestureRecognizer()
    }
    
    //MARK: setting up elements
    private func setupCurrentDate() {
        if (year == 0 || month == 0 || day == 0) {
            let todayComponents = calendar.components(NSCalendarUnit.Year.union(NSCalendarUnit.Month).union(NSCalendarUnit.Day), fromDate: NSDate())
            year = todayComponents.year
            month = todayComponents.month
            day = todayComponents.day
        }
    }
    
    private func setupMonthNameLabel() {
        monthNameLabel.font = monthNameFont
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMMM"
        monthNameLabel.text = formatter.stringFromDate(currentDate!)
        monthNameLabel.textColor = fontColor
        monthNameLabel.sizeToFit()
        addSubview(monthNameLabel)
    }
    
    private func setupYearLabel() {
        yearLabel.font = yearFont
        yearLabel.textColor = fontColor
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy"
        let yearText = formatter.stringFromDate(currentDate!)
        yearLabel.text = ""
        for character in yearText.characters {
            yearLabel.text!.append(character)
            yearLabel.text!.append(Character(" "))
        }
        yearLabel.sizeToFit()
        addSubview(yearLabel)
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
            let dayNumberCell = HeatMapCell()
            let dayLabel = dayNumberCell.dayNumberLabel
            dayLabel.font = dayNumberFont
            dayLabel.textColor = fontColor
            dayLabel.text = String(dayNumber)
            dayLabel.sizeToFit()
            dayNumbers.append(dayNumberCell)
            dayNumberCell.backgroundColor = Colors.almostBlack()
            addSubview(dayNumberCell)
        }
    }
    
    private func setupCurrentDateLabel() {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEEE d MMMM"
        currentDateLabel.font = currentDateFont
        currentDateLabel.textColor = fontColor
        currentDateLabel.text = formatter.stringFromDate(currentDate!)
        currentDateLabel.sizeToFit()
        addSubview(currentDateLabel)
    }
    
    private func setupHoursWorkedLabel() {
        hoursWorkedLabel.font = hoursWorkedFont
        hoursWorkedLabel.textColor = fontColor
        hoursWorkedLabel.text = "2 hours, 10 minutes"
        hoursWorkedLabel.sizeToFit()
        addSubview(hoursWorkedLabel)
    }
    
    private func setupTapGestureRecognizer() {
        tapGestureRecognizer.addTarget(self, action: #selector(MonthHeatMapView.handleTapGesture(_:)))
        tapGestureRecognizer.delegate = self
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    //MARK: Handle tap gesture recognition
    func handleTapGesture(recognizer:UITapGestureRecognizer) {
        
        func updateCurrentDateLabel() {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEEE d MMMM"
            currentDateLabel.text = formatter.stringFromDate(currentDate!)
            currentDateLabel.sizeToFit()
        }
        
        for dayNumberCell in dayNumbers {
            if dayNumberCell.pointInside(recognizer.locationInView(dayNumberCell), withEvent: nil) {
                day = dayNumberCell.getDayNumber()!
                updateCurrentDateLabel()
                break
            }
        }
    }
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
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
        cDistance = (frame.size.width - cellSize.width) / 6.0
    }
    
    //MARK: laying elements out
    func preferredHeight() -> CGFloat {
        return yOffset
    }
    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(UIViewNoIntrinsicMetric, preferredHeight())
    }
    
    private func layoutMonthNameLabel() {
        monthNameLabel.frame.origin = CGPointMake(0, 0)
        yOffset = monthNameLabel.frame.height + 5
    }
    
    private func layoutYearLabel() {
        yearLabel.frame.origin = CGPointMake(0, yOffset)
        yOffset += yearLabel.frame.height
        yOffset += 30
    }
    
    private func layoutDayNames() {
        sun.layer.position = CGPointMake(cellSize.width/2.0, yOffset + sun.frame.height/2.0)
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
        for dayNumberCell in dayNumbers {
            dayNumberCell.frame.size = CGSizeMake(cDistance, cDistance)
            dayNumberCell.layer.position = CGPointMake(x,y)
            //advance the position
            if x == sat.layer.position.x {
                x = sun.layer.position.x
                y += cDistance
            } else {
                x += cDistance
            }
        }
        
        //update the yOffset
        let lastDayNumberLabel = dayNumbers.last!
        yOffset = lastDayNumberLabel.frame.origin.y + lastDayNumberLabel.frame.size.height
        yOffset += 20
    }
    
    private func layoutCurrentDateLabel() {
        currentDateLabel.frame.origin = CGPointMake(0, yOffset)
        yOffset += currentDateLabel.frame.size.height
        yOffset += 5
    }
    
    private func layoutHoursWorkedLabel() {
        hoursWorkedLabel.frame.origin = CGPointMake(0, yOffset)
        yOffset += hoursWorkedLabel.frame.size.height
    }
    
    func heightToFit() {
        if frame.width != previousWidth {
            computeCellSize() //Cell size could be computed in doBasicInit but it makes sense for me to keep it here
            computeCDistance()
            //the order in which layout methods are called is imoirtant. Laying out from top to bottom.
            layoutMonthNameLabel()
            layoutYearLabel()
            layoutDayNames()
            layoutDayNumbers()
            layoutCurrentDateLabel()
            layoutHoursWorkedLabel()
            previousWidth = frame.width
        }
        frame.size = CGSizeMake(frame.width, preferredHeight())
        invalidateIntrinsicContentSize()
    }
}
