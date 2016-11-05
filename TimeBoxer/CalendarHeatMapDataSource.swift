//
//  CalndearHeatMapDataSource.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 03/08/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

protocol CalendarHeatMapDataSource {
    func heat(year:Int, month: Int, day: Int) -> CGFloat
    func startDate() -> NSDate
    func startDateTimeZone() -> NSTimeZone
    func totalSeconds(year:Int, month:Int, day: Int) -> Int
}
