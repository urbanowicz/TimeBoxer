//
//  UIControlsTestViewController.swift
//  TimeBoxer
//
//  Created by Tomasz on 27/02/16.
//  Copyright © 2016 Tomasz. All rights reserved.
//

import UIKit

class UIControlsTestViewController: UIViewController, UITableViewDataSource {
  
    @IBOutlet weak var statsTableView: UITableView!
    let statsTableDataSource = StatsTableDataSource()

    let cellId = "statsCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.almostBlack()
        //statsTableView.delegate = self
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
    
    //MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId) as! StatsTableViewCell
        //cell.textLabel?.text = "HAHA"
        return cell
    }
    
}
