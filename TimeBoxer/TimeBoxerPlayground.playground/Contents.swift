
import UIKit

struct WorkChunk {
    var date:NSDate
    var duration:Int
}

let formatter = NSDateFormatter()
formatter.dateFormat = "h:m:s"
let components = NSDateComponents()
components.second = 10*3630
let timeString = formatter.stringFromDate(NSCalendar.currentCalendar().dateFromComponents(components)!)
let timeStringComponents = timeString.componentsSeparatedByString(":")
let hours = timeStringComponents[0]
let minutes = timeStringComponents[1]
let seconds = timeStringComponents[2]










