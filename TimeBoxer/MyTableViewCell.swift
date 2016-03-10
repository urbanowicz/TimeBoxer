//
//  MyTableViewCell.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 19/01/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    var project:Project?
    var panGestureRecognizerDelegate:ProjectsTableCellPanGestureDelegate?
    
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style:UITableViewCellStyle.Value1, reuseIdentifier:reuseIdentifier)
//    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
