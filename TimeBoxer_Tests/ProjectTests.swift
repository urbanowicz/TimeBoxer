//
//  ProjectTests.swift
//  TimeBoxer
//
//  Created by Tomasz on 07/02/16.
//  Copyright © 2016 Tomasz. All rights reserved.
//

import XCTest

class ProjectTests: XCTestCase {
    var project1: Project?
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        project1 = Project(projectName: "project1", startDate: NSDate())
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        XCTAssert(project1!.name == "project1")
    }
    
}
