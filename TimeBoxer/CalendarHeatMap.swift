//
//  CalendarHeatMap.swift
//  TimeBoxer
//
//  Created by Tomasz on 26/07/16.
//  Copyright © 2016 Tomasz. All rights reserved.
//

import UIKit

class CalendarHeatMap: UIView {
    
    let sun = UILabel()
    let mon = UILabel()
    let tue = UILabel()
    let wed = UILabel()
    let thu = UILabel()
    let fri = UILabel()
    let sat = UILabel()
    
    let dayNameFont = UIFont(name: "Avenir-Book", size: 12)
    let dayNumberFont = UIFont(name: "Menlo-Regular", size: 12)
    let fontColor = UIColor.whiteColor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        doBasicInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
        doBasicInit()
    }
    
    override var bounds: CGRect {
        didSet {
            layoutDayNames()
        }
    }
    
    private func doBasicInit() {
        //init day names
        func initLabelWithText(text:String, label:UILabel) {
            label.font = dayNameFont
            label.text = text
            label.textColor = fontColor
            label.sizeToFit()
            addSubview(label)
        }

        initLabelWithText("S", label: sun)
        initLabelWithText("M", label: mon)
        initLabelWithText("T", label: tue)
        initLabelWithText("W", label: wed)
        initLabelWithText("T", label: thu)
        initLabelWithText("F", label: fri)
        initLabelWithText("S", label: sat)
        
    }
    
    private func layoutDayNames() {
        //find the size of the cell that each symbol in the calendar will take
        let sampleCalendarCell = UILabel()
        sampleCalendarCell.font = dayNumberFont
        sampleCalendarCell.text = "00"
        sampleCalendarCell.sizeToFit()
        let cellSize = sampleCalendarCell.frame.size
        
        //find 7 center points, each center for a different day of the week
        let distanceBetweenCenters = (bounds.width - cellSize.width) / 6.0
        sun.layer.position = CGPointMake(cellSize.width/2.0, cellSize.height/2.0)
        mon.layer.position = CGPointMake(sun.layer.position.x + distanceBetweenCenters, sun.layer.position.y)
        tue.layer.position = CGPointMake(mon.layer.position.x + distanceBetweenCenters, sun.layer.position.y)
        wed.layer.position = CGPointMake(tue.layer.position.x + distanceBetweenCenters, sun.layer.position.y)
        thu.layer.position = CGPointMake(wed.layer.position.x + distanceBetweenCenters, sun.layer.position.y)
        fri.layer.position = CGPointMake(thu.layer.position.x + distanceBetweenCenters, sun.layer.position.y)
        sat.layer.position = CGPointMake(fri.layer.position.x + distanceBetweenCenters, sun.layer.position.y)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
