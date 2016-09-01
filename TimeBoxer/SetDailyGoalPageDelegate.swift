//
//  SetDailyGoalPageDelegate.swift
//  TimeBoxer
//
//  Created by Tomasz on 31/08/16.
//  Copyright © 2016 Tomasz. All rights reserved.
//

import UIKit

protocol SetDailyGoalPageDelegate {
    func didPressBackButton() 
    func didSetDailyGoal(dailyGoalSeconds:Int)
}
