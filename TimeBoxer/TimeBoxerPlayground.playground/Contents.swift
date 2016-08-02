
import UIKit

let formatter = NSDateFormatter()
formatter.dateFormat = "yyyy-MM-d"

let date = formatter.dateFromString("2016-08-31")!
let calendar = NSCalendar.currentCalendar()
calendar.dateByAddingUnit(NSCalendarUnit.Month, value: 1, toDate: date, options: NSCalendarOptions.MatchNextTime)


let dayNumber = UILabel()
dayNumber 