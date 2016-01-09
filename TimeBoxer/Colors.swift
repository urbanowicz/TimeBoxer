//
//  Colors.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 09.01.2016.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class Colors: NSObject {
    private static var colorNameToUIColor : [ColorName : UIColor] =
    [
        ColorName.ALMOST_BLACK : UIColor(white:0.15, alpha:1.0),
        ColorName.WHITE : UIColor(white:1.0, alpha:1.0),
        ColorName.OFF_WHITE : UIColor(red:1.0, green:0.945, blue: 0.902, alpha:1.0),
        ColorName.LIGHT_GRAY : UIColor(white:0.52, alpha:1.0),
        ColorName.VERY_LIGHT_GRAY : UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
    ]

//----------------------------------------------------------------------------------------------------------------------
    static func toUIColor(colorName:ColorName) -> UIColor? {
        return colorNameToUIColor[colorName]
    }
}
