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
    
    func testCase1() {
        let date:NSDate? = nil
        let string = formatter.formatLastWorkedOnString(date)
        XCTAssert(string == "never")
    }
    func testCase2() {
        
    }
    
    private func dateByAddingDays(days:Int) -> NSDate {
        let now = NSDate()
        return NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: days, toDate: now, options: NSCalendarOptions())!
        
    }
    
    private func timeByAddingMinutes(minutes:Int) -> NSDate {
        let now = NSDate()
        return NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Minute, value: minutes, toDate: now, options: NSCalendarOptions())!
    }
    
}
