//
//  UIControlsTestViewController.swift
//  TimeBoxer
//
//  Created by Tomasz on 27/02/16.
//  Copyright © 2016 Tomasz. All rights reserved.
//

import UIKit

class UIControlsTestViewController: UIViewController {
  
    
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var TableCellView: UIView!
    @IBOutlet weak var appTitleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.almostBlack()
        projectNameLabel.textColor = Colors.almostBlack()
        TableCellView.backgroundColor = Colors.almostBlack()
        appTitleLabel.textColor = Colors.offWhite()
    }
    
    override func viewDidAppear(animated: Bool) {
       
    }
    
    override func viewDidLayoutSubviews() {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
