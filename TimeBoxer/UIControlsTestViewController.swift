//
//  UIControlsTestViewController.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 27/02/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class UIControlsTestViewController: UIViewController {
  
    @IBOutlet weak var statsTableView: UITableView!
    let statsTableDataSource = StatsTableDataSource()

    let cellId = "statsCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.almostBlack()
        statsTableView.backgroundColor = Colors.almostBlack()
        statsTableView.dataSource = statsTableDataSource
    }
    
    override func viewWillAppear(animated: Bool) {
        
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
