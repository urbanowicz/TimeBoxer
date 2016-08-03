//
//  NSCalendarExtension.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 27/03/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

extension NSCalendar {
    func createDate(withYear year:Int, month:Int, day:Int) -> NSDate? {
        let components = NSDateComponents()
        components.year = year
        components.month = month
        components.day = day
        
        return self.dateFromComponents(components)
    }
}
