//
//  SettingModifierDelegate.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 15/09/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

protocol SettingModifierDelegate {
    func didCancelEditing(sender:UIViewController)
    func didCommitEditing(sender:UIViewController)
}
