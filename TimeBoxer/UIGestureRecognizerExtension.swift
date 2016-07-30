//
//  UIGestureRecognizerExtension.swift
//  TimeBoxer
//
//  Created by Tomasz on 30/07/16.
//  Copyright © 2016 Tomasz. All rights reserved.
//

import UIKit

extension UIGestureRecognizer {
    func cancel() {
        enabled = false
        enabled = true
    }
}