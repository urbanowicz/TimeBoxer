
import UIKit
let formatter = NSDateFormatter()
formatter.dateFormat = "yyyy"
let yearText = formatter.stringFromDate(NSDate())
var text = ""
for character in yearText.characters {
    text.append(character)
    text.append(Character(" "))
}

text 