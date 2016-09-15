//
//  MarkAsFinishedViewController.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 14/09/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

protocol ProjectSettingsPageDelegate {
    func didPressEditProjectName()
    func didPressChangeDailyGoal()
    func didPressDeleteProject()
}
