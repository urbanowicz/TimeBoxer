//
//  MonthHeatMapView.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 29/07/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class MonthHeatMapView: UIView, UIGestureRecognizerDelegate {
    
    private let calendar = NSCalendar.gmtCalendar()
    
    private var year:Int = 0
    private var month:Int = 0
    private var day:Int = 0
    
    var currentDateComponents:NSDateComponents {
        get {
            let currentDateComponents = NSDateComponents()
            currentDateComponents.year = year
            currentDateComponents.month = month
            currentDateComponents.day = day
            currentDateComponents.hour = 0
            currentDateComponents.minute = 0
            currentDateComponents.second = 0
            currentDateComponents.nanosecond = 0
            return currentDateComponents
        }
    }
    
    private let monthNameLabel = UILabel()
    private let yearLabel = UILabel()
    
    private let sun = UILabel()
    private let mon = UILabel()
    private let tue = UILabel()
    private let wed = UILabel()
    private let thu = UILabel()
    private let fri = UILabel()
    private let sat = UILabel()
    
    private var dayNames = [UILabel]()
    
    private var dayNumbers = [HeatMapCell]()
    
    private var currentHeatMapCell:HeatMapCell?
    
    private let currentDateLabel = UILabel()
    
    private let hoursWorkedLabel = UILabel()
    
    let monthNameFont = UIFont(name:"Avenir-Heavy", size: 22)
    let yearFont = UIFont(name: "Menlo-Regular", size: 12)
    let dayNameFont = UIFont(name: "Avenir-Book", size: 12)
    let dayNumberFont = UIFont(name: "Menlo-Regular", size: 12)
    let currentDateFont = UIFont(name: "Avenir-Medium", size: 14)
    let hoursWorkedFont = UIFont(name: "Avenir-Heavy", size: 16)
    let fontColor = Colors.silver()
    
    //cellSize is the size of the bounding rectangle inside of which each element of the calendar will fit.
    private var cellSize:CGSize = CGSizeZero
    
    //cDistance variable is key to laying out the elements of the calendar.
    //it is a distance between centers of two consecutive elements in the calendar. Both in y and x direction.
    //eg. S M T W T F S. The distance between the centers of these letters is equal to cDistance.
    private var cDistance:CGFloat  {
        get {
            return frame.size.width / 7.0
        }
    }
    
    //this is a computed margin that all labels will be alligined to. i.e their x value will be set to leftMargin
    var leftMargin:CGFloat {
        get {
            return (cDistance/2.0) - (cellSize.width / 2.0)
        }
    }
    
    //yOffset is used for laying out elements along the y axis. Eg. After the name of the month had been laid out
    //the yOoffset i set to where the next element should be positioned on the y axis.
    private var yOffset:CGFloat = 0.0
    
    private var previousWidth:CGFloat = 0.0
    
    private let tapGestureRecognizer:UITapGestureRecognizer = UITapGestureRecognizer()
    
    var dataSource: CalendarHeatMapDataSource? {
        didSet {
            refreshHeatMap()
        }
    }
    
    convenience init(year:Int, month:Int, day:Int) {
        self.init(frame: CGRectZero)
        self.year = year
        self.month = month
        self.day = day
        doBasicInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func doBasicInit() {
        computeCellSize()
        setupMonthNameLabel()
        setupYearLabel()
        setupDayNames()
        setupDayNumbers()
        setupCurrentDateLabel()
        setupHoursWorkedLabel()
        setupTapGestureRecognizer()
    }

    
    private func setupCurrentDateLabel() {
        let localCalendar = NSCalendar.currentCalendar()
        let currentDate = localCalendar.dateFromComponents(currentDateComponents)
        let formatter = NSDateFormatter()
        formatter.timeZone = localCalendar.timeZone
        formatter.dateFormat = "EEEE d MMMM"
        currentDateLabel.font = currentDateFont
        currentDateLabel.textColor = fontColor
        currentDateLabel.text = formatter.stringFromDate(currentDate!)
        currentDateLabel.sizeToFit()
        addSubview(currentDateLabel)
    }
    
    private func setupMonthNameLabel() {
        let localCalendar = NSCalendar.currentCalendar()
        let currentDate = localCalendar.dateFromComponents(currentDateComponents)
        monthNameLabel.font = monthNameFont
        let formatter = NSDateFormatter()
        formatter.timeZone = localCalendar.timeZone
        formatter.dateFormat = "MMMM"
        monthNameLabel.text = formatter.stringFromDate(currentDate!)
        monthNameLabel.textColor = fontColor
        monthNameLabel.sizeToFit()
        addSubview(monthNameLabel)
    }
    
    private func setupYearLabel() {
        let localCalendar = NSCalendar.currentCalendar()
        let currentDate = localCalendar.dateFromComponents(currentDateComponents)
        yearLabel.font = yearFont
        yearLabel.textColor = fontColor
        let formatter = NSDateFormatter()
        formatter.timeZone = localCalendar.timeZone
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
            let dayNumberCell = HeatMapCell(withYear: year, month: month, day: dayNumber)
            dayNumberCell.backgroundColor = Colors.almostBlack()
            dayNumbers.append(dayNumberCell)
            addSubview(dayNumberCell)
            
            //select the current day number
            if dayNumber == self.day {
                dayNumberCell.select()
                currentHeatMapCell = dayNumberCell
            }
        }
    }
    

    
    private func setupHoursWorkedLabel() {
        hoursWorkedLabel.font = hoursWorkedFont
        hoursWorkedLabel.textColor = fontColor
        hoursWorkedLabel.text = ""
        hoursWorkedLabel.sizeToFit()
        addSubview(hoursWorkedLabel)
    }
    
    private func setupTapGestureRecognizer() {
        tapGestureRecognizer.addTarget(self, action: #selector(MonthHeatMapView.handleTapGesture(_:)))
        tapGestureRecognizer.delegate = self
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func updateHoursWorkedLabel(forCell cell: HeatMapCell) {
        
        func updateText(text:String) {
            if text != hoursWorkedLabel.text {
                let animation: CATransition = CATransition()
                animation.duration = 0.2
                animation.type = kCATransitionFade
                animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                hoursWorkedLabel.layer.addAnimation(animation, forKey: "changeTextTransition")
                hoursWorkedLabel.text = text
            }
        }
        
        if cell.active {
            
            let totalSeconds = dataSource!.totalSeconds(cell.year, month: cell.month, day: cell.day)
            let workTimeFormatter = WorkTimeFormatter()
            updateText(workTimeFormatter.formatLong(totalSeconds))
            hoursWorkedLabel.alpha = 1.0
            hoursWorkedLabel.sizeToFit()
            
        } else {
            updateText("No entry for this date")
            hoursWorkedLabel.sizeToFit()
            hoursWorkedLabel.alpha = 0.3
        }
    }
    
    
    //MARK: Handle tap gesture recognition
    func handleTapGesture(recognizer:UITapGestureRecognizer) {
        
        func updateText(text:String) {
            if text != currentDateLabel.text {
                let animation: CATransition = CATransition()
                animation.duration = 0.2
                animation.type = kCATransitionFade
                animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                currentDateLabel.layer.addAnimation(animation, forKey: "changeTextTransition")
                currentDateLabel.text = text
            }
        }
        
        func updateCurrentDateLabel() {
            let localCalendar = NSCalendar.currentCalendar()
            let currentDate = localCalendar.dateFromComponents(currentDateComponents)
            let formatter = NSDateFormatter()
            formatter.timeZone = localCalendar.timeZone
            formatter.dateFormat = "EEEE d MMMM"
            updateText(formatter.stringFromDate(currentDate!))
            currentDateLabel.sizeToFit()
        }
        
        for dayNumberCell in dayNumbers {
            if dayNumberCell.pointInside(recognizer.locationInView(dayNumberCell), withEvent: nil) {
                day = dayNumberCell.getDayNumber()
                currentHeatMapCell?.deselect()
                dayNumberCell.select()
                currentHeatMapCell = dayNumberCell
                updateCurrentDateLabel()
                
                updateHoursWorkedLabel(forCell: dayNumberCell)
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
    
    //MARK: laying elements out
    func preferredHeight() -> CGFloat {
        return yOffset
    }
    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(UIViewNoIntrinsicMetric, preferredHeight())
    }
    
    private func layoutMonthNameLabel() {
        //Remember that cDistance is the distance between the centers of two day numbers.
        //Hence cDistance/2.0 is the radius of the circle that goes around the day number
        //Since we're setting frame's origin using a center coordianate, we need to shift it back
        //by cellSize.width / 2.0
        monthNameLabel.frame.origin = CGPointMake(leftMargin, 0)
        yOffset = monthNameLabel.frame.height + 5
    }
    
    private func layoutYearLabel() {
        yearLabel.frame.origin = CGPointMake(leftMargin, yOffset)
        yOffset += yearLabel.frame.height
        yOffset += 30
    }
    
    private func layoutDayNames() {
        sun.layer.position = CGPointMake(cDistance/2.0, yOffset + sun.frame.height/2.0)
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
        
        currentDateLabel.frame.origin = CGPointMake(leftMargin, yOffset)
        yOffset += currentDateLabel.frame.size.height
        yOffset += 5
    }
    
    private func layoutHoursWorkedLabel() {
        hoursWorkedLabel.frame.origin = CGPointMake(leftMargin, yOffset)
        yOffset += hoursWorkedLabel.frame.size.height
    }
    
    
    func refreshHeatMap() {
        
        //mark cells as active or inactive. Inactive are the ones in the future and before the start date
        let localCalendar = NSCalendar.currentCalendar()
        let calendarUsedWhenProjectWasStarted = NSCalendar.currentCalendar()
        calendarUsedWhenProjectWasStarted.timeZone = dataSource!.startDateTimeZone()
        //start date expressed in the time zone in which the project was started
         let startDateComps = calendarUsedWhenProjectWasStarted.components(NSCalendarUnit.Day.union(NSCalendarUnit.Month).union(NSCalendarUnit.Year), fromDate: dataSource!.startDate())
    

        //current date and time expressed in the current time zone
        let nowComps = localCalendar.components(NSCalendarUnit.Day.union(NSCalendarUnit.Month).union(NSCalendarUnit.Year), fromDate: NSDate())
        for dayNumberCell in dayNumbers {
            let dayNumber = dayNumberCell.getDayNumber()
            let startDate = localCalendar.dateFromComponents(startDateComps)!
            let nowDate = localCalendar.dateFromComponents(nowComps)!
            let currentDayComps = NSDateComponents()
            currentDayComps.year = year
            currentDayComps.month = month
            currentDayComps.day = dayNumber
            let currentDay = localCalendar.dateFromComponents(currentDayComps)!
            var isAfterStartDate = true
            var comparisonResult = localCalendar.compareDate(startDate, toDate: currentDay, toUnitGranularity: .Day)
            if (comparisonResult == NSComparisonResult.OrderedSame || comparisonResult == NSComparisonResult.OrderedAscending) {
                isAfterStartDate = true
            } else {
                isAfterStartDate = false
            }
            
            comparisonResult = localCalendar.compareDate(currentDay, toDate: nowDate, toUnitGranularity: .Day )
            var isBeforeNow = true
            if (comparisonResult == NSComparisonResult.OrderedSame || comparisonResult == NSComparisonResult.OrderedAscending) {
                isBeforeNow = true
            } else {
                isBeforeNow = false
            }
            if isAfterStartDate && isBeforeNow {
                dayNumberCell.active = true
                dayNumberCell.heat = dataSource!.heat(year, month: month, day: dayNumber)
            } else {
                dayNumberCell.active = false
             }
        }
        
        updateHoursWorkedLabel(forCell: currentHeatMapCell!)
    }
    
    func heightToFit() {
        if frame.width != previousWidth {
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
