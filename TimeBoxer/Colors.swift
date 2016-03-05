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
        ColorName.VERY_LIGHT_GRAY : UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0),
        ColorName.AZURE : UIColor(red: 0.902, green: 1, blue: 1, alpha: 1),
    ]

//----------------------------------------------------------------------------------------------------------------------
    static func toUIColor(colorName:ColorName) -> UIColor? {
        return colorNameToUIColor[colorName]
    }
    
    static func almostBlack() -> UIColor {
        return UIColor(white:0.15, alpha:1.0)
    }
    
    static func offWhite() -> UIColor {
        return UIColor(red:1.0, green:0.945, blue: 0.902, alpha:1.0)
    }
    
    static func lightGray() -> UIColor {
        return UIColor(white:0.52, alpha:1.0)
    }
    
    static func veryLightGray() -> UIColor {
        return UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
    }
    
    static func azure() -> UIColor {
        return UIColor(red: 0.902, green: 1, blue: 1, alpha: 1)
    }
    
    static func seafoam() -> UIColor {
        return UIColor(red: 0.902, green: 1, blue: 0.914, alpha:1)
    }
    
    static func oceanBlue() -> UIColor {
        return UIColor(red:0.243, green:0.325, blue:0.404, alpha:1)
    }
 
}
