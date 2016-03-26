
import UIKit

struct WorkChunk {
    var date:NSDate
    var duration:Int
}

let formatter = NSDateFormatter()
formatter.dateFormat = "dd-MMM-yyyy hh:mm:ss"

func dateToWeek(date:NSDate) -> [NSDate] {
    let calendar = NSCalendar.currentCalendar()
    let components = calendar.components([NSCalendarUnit.Weekday], fromDate:date)
    let numberOfDaysSinceMonday = components.weekday - 2
    let monday = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: -numberOfDaysSinceMonday, toDate: date, options: NSCalendarOptions.WrapComponents)!
    var week = [monday]
    for i in 1 ... 6 {
        week.append(calendar.dateByAddingUnit(NSCalendarUnit.Day, value: i, toDate: monday, options: NSCalendarOptions.WrapComponents)!)
    }
    return week
}


func dayDifferenceBetween(laterDate: NSDate, earlierDate: NSDate) -> Int {
    let calendar = NSCalendar.currentCalendar()
    let laterDateNoTimeComponent = dateWithNoTimeComponentFromDate(laterDate)
    let earlierDateNoTimeComponent = dateWithNoTimeComponentFromDate(earlierDate)
    let dayDifference =
    calendar.components(NSCalendarUnit.Day, fromDate: earlierDateNoTimeComponent, toDate: laterDateNoTimeComponent, options: [])
    return dayDifference.day
}

func dateWithNoTimeComponentFromDate(date: NSDate) -> NSDate {
    let calendar = NSCalendar.currentCalendar()
    var unit = NSCalendarUnit.Year
    unit.unionInPlace(NSCalendarUnit.Month)
    unit.unionInPlace(NSCalendarUnit.Day)
    let components = calendar.components(unit, fromDate: date)
    components.second = 0
    components.minute = 0
    components.hour = 0
    components.nanosecond = 0
    return calendar.dateFromComponents(components)!
}

//week1
let w1 = WorkChunk(date: formatter.dateFromString("15-Mar-2016 00:00:00")!, duration:1000)
let w2 = WorkChunk(date: formatter.dateFromString("18-Mar-2016 00:00:00")!, duration:2000)
let w3 = WorkChunk(date: formatter.dateFromString("18-Mar-2016 00:00:00")!, duration:1500)
//week2
let w4 = WorkChunk(date: formatter.dateFromString("21-Mar-2016 10:00:00")!, duration:300)
let w5 = WorkChunk(date: formatter.dateFromString("23-Mar-2016 00:00:00")!, duration:3600)
let w6 = WorkChunk(date: formatter.dateFromString("23-Mar-2016 00:00:00")!, duration:2000)

var workChunks = [w1,w2,w3,w4,w5,w6]

func workChunksWithDate(date:NSDate) ->[WorkChunk] {
    let calendar = NSCalendar.currentCalendar()
    var result = [WorkChunk]()
    var comparisonResult = NSComparisonResult.OrderedDescending
    for i in 0 ..< workChunks.count {
        let workChunkDate = workChunks[i].date
        comparisonResult = calendar.compareDate(workChunkDate, toDate: date, toUnitGranularity: .Day)
        if comparisonResult == NSComparisonResult.OrderedSame {
            result.append(workChunks[i])
        }
        if comparisonResult == NSComparisonResult.OrderedDescending {
            break
        }
        
    }
    return result
}

let week = dateToWeek(w1.date)

workChunksWithDate(NSDate()).count
dayDifferenceBetween(w5.date, earlierDate: w4.date)

let calendar = NSCalendar.currentCalendar()
var unit = NSCalendarUnit.Year
unit.unionInPlace(NSCalendarUnit.Month)
unit.unionInPlace(NSCalendarUnit.Day)
calendar.components(unit, fromDate: w5.date).year

//--------------------------------------------------------------------------









