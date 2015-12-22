//
//  InvertedCancelButton.swift
//  TimeBoxer_v0
//
//  Created by Tomasz on 07.11.2015.
//  Copyright © 2015 Tomasz. All rights reserved.
//

import UIKit

class InvertedCancelButton: CancelButton {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        frontLayerColor = UIColor(red:0.15, green:0.15, blue:0.15, alpha:1.0)
        frontLayerHighlightedColor = UIColor(red:0.15, green:0.15, blue:0.15, alpha:1.0)
        ovalLayerColor = UIColor.whiteColor()
        ovalLayerHighlightedColor = UIColor(red:0.58, green:0.58, blue:0.58, alpha:1.0)
    }
}
