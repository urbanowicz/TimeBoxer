//
//  UIControlsTestViewController.swift
//  TimeBoxer
//
//  Created by Tomasz on 27/02/16.
//  Copyright © 2016 Tomasz. All rights reserved.
//

import UIKit

class UIControlsTestViewController: UIViewController {
    let blackColor = Colors.almostBlack()

    @IBOutlet weak var testLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        setupTestLabel()

    }
    
    private func setupTestLabel() {
        testLabel.font = testLabel.font.fontWithSize(20.0)
        testLabel.numberOfLines = 2
        testLabel.sizeToFit()
        print(testLabel.frame.size.height)
        print(testLabel.font.lineHeight)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
