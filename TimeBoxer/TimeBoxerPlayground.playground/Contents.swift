//: Playground - noun: a place where people can play

import UIKit

//get the calendar
let calendar = NSCalendar.currentCalendar()

//let's create a couple of dates
let now = NSDate()
let threeDaysAgo = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: -3, toDate: now, options: NSCalendarOptions())

let components = calendar.components(NSCalendarUnit.Day, fromDate: threeDaysAgo!, toDate: now, options: NSCalendarOptions())
components.day

