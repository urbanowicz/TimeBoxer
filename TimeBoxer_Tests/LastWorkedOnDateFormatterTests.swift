//
//  LastWorkedOnDateFormatterTests.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 10/02/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import XCTest

class LastWorkedOnDateFormatterTests: XCTestCase {
    let formatter:LastWorkedOnDateFormatter = LastWorkedOnDateFormatter()
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLastWorkedOnInTheFuture() {
        let date = timeByAddingMinutes(20)
        let string = formatter.formatLastWorkedOnString(date)
        XCTAssert(string == "")
    }
    
    func testCase1() {
        let string = formatter.formatLastWorkedOnString(nil)
        XCTAssert(string == "never")
    }
    func testCase2() {
        var date = timeByAddingMinutes(-1)
        var string = formatter.formatLastWorkedOnString(date)
        XCTAssert(string == "1 minute ago")
        date = timeByAddingMinutes(-10)
        string = formatter.formatLastWorkedOnString(date)
        XCTAssert(string == "10 minutes ago")
    }
    func testCase3() {
        let date = timeByAddingMinutes(-60)
        let string = formatter.formatLastWorkedOnString(date)
        XCTAssert(string == "1 hour ago")
    }
    
    func testCase4() {
        let date = timeByAddingMinutes(-65)
        let string = formatter.formatLastWorkedOnString(date)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        XCTAssert(string == dateFormatter.stringFromDate(date))
    }
    
    func testCase5() {
        let date = dateByAddingDays(-1)
        let string = formatter.formatLastWorkedOnString(date)
        XCTAssert(string == "yesterday")
    }
    
    func testCase6() {
        let date = dateByAddingDays(-120)
        let string = formatter.formatLastWorkedOnString(date)
        XCTAssert(string == "120 days ago")
    }
    
    func testCase7() {
        let date = dateByAddingDays(-362)
        let string = formatter.formatLastWorkedOnString(date)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        XCTAssert(string == dateFormatter.stringFromDate(date))
    }
    
    
    //MARK: Helper functions
    private func dateByAddingDays(days:Int) -> NSDate {
        let now = NSDate()
        return NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: days, toDate: now, options: NSCalendarOptions())!
        
    }
    
    private func timeByAddingMinutes(minutes:Int) -> NSDate {
        let now = NSDate()
        return NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Minute, value: minutes, toDate: now, options: NSCalendarOptions())!
    }
    
}
