//
//  UIColorExtension.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 10/04/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

extension UIColor {
    func withAlpha(alpha: CGFloat) -> UIColor {
        var red = CGFloat()
        var green = CGFloat()
        var blue = CGFloat()
        var oldAlpha = CGFloat()
        self.getRed(&red, green: &green, blue: &blue, alpha: &oldAlpha)
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
