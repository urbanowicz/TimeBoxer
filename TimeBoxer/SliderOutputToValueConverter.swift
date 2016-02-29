//
//  SliderOutputToValueConverter.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 29/02/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class SliderOutputToValueConverter: NSObject {
    var maxValue:Int
    var resolution:Int
    init(maxValue:Int, resolution:Int) {
        self.maxValue = maxValue
        self.resolution = resolution
    }
    
    func convert(sliderValue:Double) -> Int {
        let bucket = Int((sliderValue * Double(maxValue)) / Double(resolution))
        return resolution * (bucket+1)
    }

}
