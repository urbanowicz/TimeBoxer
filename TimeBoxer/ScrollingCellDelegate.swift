//
//  ScrollingCellDelegate.swift
//  TimeBoxer
//
//  Created by Tomasz on 23/08/16.
//  Copyright © 2016 Tomasz. All rights reserved.
//

import UIKit

protocol ScrollingCellDelegate {
    func scrollingCellDidBeginPulling(cell:MyTableViewCell)
    func scrollingCellDidChangePullOffset(offset:CGFloat)
    func scrollingCellDidEndPulling(cell:MyTableViewCell)
}
