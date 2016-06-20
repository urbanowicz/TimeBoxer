
import UIKit

func dayDifferenceBetween(laterDate: NSDate, earlierDate: NSDate) -> Int {
    let calendar = NSCalendar.currentCalendar()
    
    let earlierStartOfDay = calendar.startOfDayForDate(earlierDate)
    let laterStartOfDay = calendar.startOfDayForDate(laterDate)
    
    let dayDifference =
        calendar.components(NSCalendarUnit.Day, fromDate: earlierStartOfDay, toDate: laterStartOfDay, options: .WrapComponents)
    return dayDifference.day
}

let formatter = NSDateFormatter()
formatter.dateFormat = "MM-dd-yyyy HH:mm"
let laterDate = formatter.dateFromString("06-20-2016 00:10")
let earlierDate = formatter.dateFromString("06-20-2016 23:50")

dayDifferenceBetween(laterDate!, earlierDate:earlierDate!)


