
import UIKit

struct WorkChunk {
    var date:NSDate
    var duration:Int
}

let formatter = NSDateFormatter()
formatter.dateFormat = "dd-MMM-yyyy"

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



//week1
let w1 = WorkChunk(date: formatter.dateFromString("15-Mar-2016")!, duration:1000)
let w2 = WorkChunk(date: formatter.dateFromString("18-Mar-2016")!, duration:2000)
let w3 = WorkChunk(date: formatter.dateFromString("18-Mar-2016")!, duration:1500)
//week2
let w4 = WorkChunk(date: formatter.dateFromString("21-Mar-2016")!, duration:300)
let w5 = WorkChunk(date: formatter.dateFromString("23-Mar-2016")!, duration:3600)
let w6 = WorkChunk(date: formatter.dateFromString("23-Mar-2016")!, duration:2000)

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

//--------------------------------------------------------------------------

func dayDifferenceBetween(laterDate: NSDate, earlierDate: NSDate) -> Int {
    let calendar = NSCalendar.currentCalendar()
    let dayDifference =
    calendar.components(NSCalendarUnit.Day, fromDate: earlierDate, toDate: laterDate, options: NSCalendarOptions())
    return dayDifference.day
}

let now = NSDate()
let dateStringFormatter = NSDateFormatter()
dateStringFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
let earlier = dateStringFormatter.dateFromString("2016-03-09T18:51:00")

let diff = dayDifferenceBetween(now, earlierDate: earlier!)



