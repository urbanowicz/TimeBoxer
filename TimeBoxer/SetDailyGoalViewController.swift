//
//  SetDailyGoalViewController.swift
//  TimeBoxer
//
//  Created by Tomasz on 30/08/16.
//  Copyright © 2016 Tomasz. All rights reserved.
//

import UIKit

class SetDailyGoalViewController: UIViewController {
    var delegate:SetDailyGoalPageDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.yellowColor()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func okButtonPressed(sender: AnyObject) {
        delegate?.didSetDailyGoal(3600)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
