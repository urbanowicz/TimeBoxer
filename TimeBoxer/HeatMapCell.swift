//
//  HeatMapCell.swift
//  TimeBoxer
//
//  Created by Tomasz on 02/08/16.
//  Copyright © 2016 Tomasz. All rights reserved.
//

import UIKit

class HeatMapCell: UIView {

    let dayNumberLabel:UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        doBasicInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        doBasicInit()
    }
    
    private func doBasicInit() {
        addSubview(dayNumberLabel)
    }
    
    override func layoutSubviews() {
        dayNumberLabel.layer.position.x = frame.width / 2.0
        dayNumberLabel.layer.position.y = frame.height / 2.0
    }
    
    func getDayNumber() -> Int? {
        return Int(dayNumberLabel.text!)
    }

}
