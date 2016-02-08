//
//  ProjectTests.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 07/02/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import XCTest

class ProjectTests: XCTestCase {
    override func setUp() {
        super.setUp()

    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testProjectCreation() {
        let now = NSDate()
        let myProject:Project = Project(projectName: "project", startDate: now)
        let compareResult = NSCalendar.currentCalendar().compareDate(now, toDate: myProject.startDate, toUnitGranularity: NSCalendarUnit.Day)
        XCTAssert(myProject.name == "project")
        XCTAssert(compareResult == NSComparisonResult.OrderedSame)
    }
    
    func testRecordWork() {
        let myProject = Project(projectName: "myProject", startDate: NSDate())
        XCTAssert(myProject.workChunks.count == 0)
        myProject.recordWork(3600)
        XCTAssert(myProject.workChunks.count == 1)
        XCTAssert(myProject.totalSeconds() == 3600)
        myProject.recordWork(20)
        XCTAssert(myProject.workChunks.count == 2)
        XCTAssert(myProject.totalSeconds() == 3620)
    }
    
    func testLastWorkedOn() {
        let myProject = Project(projectName: "myProject", startDate: NSDate())
        XCTAssert(myProject.lastWrokedOn() == nil)
        myProject.recordWork(3600)
        let lastWorkedOn = myProject.lastWrokedOn()
        XCTAssert(lastWorkedOn != nil)
        let compareResult = NSCalendar.currentCalendar().compareDate(NSDate(), toDate: lastWorkedOn!, toUnitGranularity: NSCalendarUnit.Day)
        XCTAssert(compareResult == NSComparisonResult.OrderedSame)
    }
    
    func testAveragePaceLastSevenDays() {
        let myProject = Project(projectName: "myProject", startDate: NSDate())
        var pace = myProject.averagePaceLastSevenDays()
        XCTAssert(pace == 0)
        myProject.recordWork(200)
        myProject.recordWork(200)
        pace = myProject.averagePaceLastSevenDays()
        XCTAssert(pace == 400)
    }
    
}
