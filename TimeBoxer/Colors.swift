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
    
    static func lightGray() -> UIColor {
        return UIColor(white:0.52, alpha:1.0)
    }
    
    static func veryLightGray() -> UIColor {
        return UIColor(red:0.45, green:0.47, blue:0.54, alpha:0.2)
    }
    
    static func kindOfGray() -> UIColor {
        return UIColor(red:0.804, green:0.804, blue:0.804, alpha:1.0)
    }
    
    static func oceanBlue() -> UIColor {
        return UIColor(red:0.243, green:0.325, blue:0.404, alpha:1)
    }
    
    static func purple() -> UIColor {
        return UIColor(red:0.478, green:0.263, blue:0.451, alpha:1)
    }
    
    static func violet() -> UIColor {
        return UIColor(red:0.29, green:0.263, blue:0.478, alpha:1.0)
    }
    
    
    //New Colors
    static func almostBlack() -> UIColor {
        return UIColor(red:0.06, green:0.06, blue:0.06, alpha:1.0)
    }
    
    static func azure() -> UIColor {
        return UIColor(red:0.58, green:1.00, blue:1.00, alpha:1.0)
    }
    
    static func silver() -> UIColor {
        return UIColor(red:0.85, green:0.90, blue:0.93, alpha:1.0)
    }
    
    static func golden() -> UIColor {
        return UIColor(red:0.93, green:0.93, blue:0.85, alpha:1.0)
    }
    
    static func green() -> UIColor {
       return UIColor(red:0.00, green:0.85, blue:0.63, alpha:1.0)
    }
}
