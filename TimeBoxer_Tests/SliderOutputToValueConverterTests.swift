//
//  SliderOutputToValueConverterTests.swift
//  TimeBoxer
//
//  Created by Tomasz on 29/02/16.
//  Copyright © 2016 Tomasz. All rights reserved.
//

import XCTest

class SliderOutputToValueConverterTests: XCTestCase {
    var converter:SliderOutputToValueConverter?
    
    override func setUp() {
        super.setUp()
        converter = SliderOutputToValueConverter(maxValue: 120, resolution: 5)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCase1() {
        let value = converter?.convert(0.5)
        XCTAssert(value == 65)
    }
    
    func testCase2() {
        let value = converter?.convert(0.0)
        XCTAssert(value == 5)
    }
    
    func testCase3() {
        let value = converter?.convert(1.0)
        XCTAssert(value == 120)
    }
    
}
