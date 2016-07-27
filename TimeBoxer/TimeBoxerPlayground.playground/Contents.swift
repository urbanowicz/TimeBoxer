
import UIKit
//
//func dayDifferenceBetween(laterDate: NSDate, earlierDate: NSDate) -> Int {
//    let calendar = NSCalendar.currentCalendar()
//    
//    let earlierStartOfDay = calendar.startOfDayForDate(earlierDate)
//    let laterStartOfDay = calendar.startOfDayForDate(laterDate)
//    
//    let dayDifference =
//        calendar.components(NSCalendarUnit.Day, fromDate: earlierStartOfDay, toDate: laterStartOfDay, options: .WrapComponents)
//    return dayDifference.day
//}
//
//let formatter = NSDateFormatter()
//formatter.dateFormat = "MM-dd-yyyy HH:mm"
//let laterDate = formatter.dateFromString("06-20-2016 00:10")
//let earlierDate = formatter.dateFromString("06-20-2016 23:50")
//
//dayDifferenceBetween(laterDate!, earlierDate:earlierDate!)


let today = NSDate()
let calendar = NSCalendar.currentCalendar()

//How many days in the current month?
let howManyDaysInAMonth = calendar.rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: today).length

//What are the components for the current dayte?
let flags = NSCalendarUnit.Year.union(NSCalendarUnit.Month).union(NSCalendarUnit.Day).union(NSCalendarUnit.Weekday)
let components = calendar.components(flags , fromDate: today)

//What day of the week is the first day of the month?
var firstDayOfTheMonthComponents = NSDateComponents()
firstDayOfTheMonthComponents.day = 1
firstDayOfTheMonthComponents.month = components.month
firstDayOfTheMonthComponents.year = components.year

let firstDayOfTheMonth = calendar.dateFromComponents(firstDayOfTheMonthComponents)!

let firstDayOfTheMonthWeekDay = calendar.components(NSCalendarUnit.Weekday, fromDate: firstDayOfTheMonth).weekday
