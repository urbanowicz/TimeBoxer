//
//  ProjectStatsView.swift
//  TimeBoxer
//
//  Created by Tomasz on 08/08/16.
//  Copyright © 2016 Tomasz. All rights reserved.
//

import UIKit

class ProjectStatsView: UIView {

    @IBOutlet weak var calendarHeatMap: CalendarHeatMap!
    
    @IBOutlet weak var projectNameTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var projectNamelLeadingConstraint: NSLayoutConstraint!


    override func updateConstraints() {
        super.updateConstraints()
        let leftMargin = calendarHeatMap.leftMargin
        projectNamelLeadingConstraint.constant = 10 + leftMargin
        projectNameTrailingConstraint.constant = 10 + leftMargin
    }
}
