//
//  StatsTableViewCell.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 21/03/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class StatsTableViewCell: UITableViewCell {

    @IBOutlet weak var mondayLabel: UILabel!
    @IBOutlet weak var mondayDateLabel: UILabel!
    @IBOutlet weak var mondayBar: HorizontalBarView!
    @IBOutlet weak var mondayInnerBarLabel: UILabel!
    @IBOutlet weak var mondayOuterBarLabel: UILabel!
    
    @IBOutlet weak var tuesdayLabel: UILabel!
    @IBOutlet weak var tuesdayDateLabel: UILabel!
    @IBOutlet weak var tuesdayBar: HorizontalBarView!
    @IBOutlet weak var tuesdayInnerBarLabel: UILabel!
    @IBOutlet weak var tuesdayOuterBarLabel: UILabel!
    
    @IBOutlet weak var wednesdayLabel: UILabel!
    @IBOutlet weak var wednesdayDateLabel: UILabel!
    @IBOutlet weak var wednesdayBar: HorizontalBarView!
    @IBOutlet weak var wednesdayInnerBarLabel: UILabel!
    @IBOutlet weak var wednesdayOuterBarLabel: UILabel!
    
    @IBOutlet weak var thursdayLabel: UILabel!
    @IBOutlet weak var thursdayDateLabel: UILabel!
    @IBOutlet weak var thursdayBar: HorizontalBarView!
    @IBOutlet weak var thursdayInnerBarLabel: UILabel!
    @IBOutlet weak var thursdayOuterBarLabel: UILabel!

    @IBOutlet weak var fridayLabel: UILabel!
    @IBOutlet weak var fridayDateLabel: UILabel!
    @IBOutlet weak var fridayBar: HorizontalBarView!
    @IBOutlet weak var fridayInnerBarLabel: UILabel!
    @IBOutlet weak var fridayOuterBarLabel: UILabel!
    
    
    @IBOutlet weak var saturdayLabel: UILabel!
    @IBOutlet weak var saturdayDateLabel: UILabel!
    @IBOutlet weak var saturdayBar: HorizontalBarView!
    @IBOutlet weak var saturdayInnerBarLabel: UILabel!
    @IBOutlet weak var saturdayOuterBarLabel: UILabel!
    
    @IBOutlet weak var sundayLabel: UILabel!
    @IBOutlet weak var sundayDateLabel: UILabel!
    @IBOutlet weak var sundayBar: HorizontalBarView!
    @IBOutlet weak var sundayInnerBarLabel: UILabel!
    @IBOutlet weak var sundayOuterBarLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
