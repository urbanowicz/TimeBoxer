//: Playground - noun: a place where people can play

import UIKit


func heightForLabel(label:UILabel, maxWidth:CGFloat) -> CGFloat {
    let text = label.text! as NSString
    let attributes = [NSFontAttributeName: label.font]
    let frameSize = CGSizeMake(maxWidth, CGFloat.max)
    let labelSize = text.boundingRectWithSize(frameSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributes, context: nil)
    return labelSize.height
}


let text = "Read on Intelligence and implement the MIDI enc"
let label = UILabel(frame:CGRectMake(0, 0, 220, 100))
label.font = UIFont(name: "Avenir", size: 18.0)
label.text = text

heightForLabel(label, maxWidth: label.frame.width)



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



