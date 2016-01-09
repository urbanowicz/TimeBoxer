//
//  Animator.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 02.01.2016.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

protocol Animator {
    func animateTransition(fromVC:UIViewController, toVC:UIViewController, container:UIView, completion: (()->Void)?)
}
