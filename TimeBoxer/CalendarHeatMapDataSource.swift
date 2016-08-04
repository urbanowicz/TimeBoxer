//
//  CalndearHeatMapDataSource.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 03/08/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

protocol CalendarHeatMapDataSource {
    func heat(withDate date:NSDate) -> CGFloat
    func startDate() -> NSDate
    func totalSeconds(withDate date:NSDate) -> Int
}
