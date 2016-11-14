
import UIKit

let now = Date()
let calendar = Calendar.current
let comps = calendar.dateComponents(in: calendar.timeZone, from: now)
let key = "\(comps.year!)\(comps.month!)\(comps.day!)"

var map = [String:Int]()
var entry = map[key]
map[key] = 30
entry = map[key]



