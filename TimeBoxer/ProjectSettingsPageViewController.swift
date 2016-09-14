//
//  ProjectSettingsPageViewController.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 14/09/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class ProjectSettingsPageViewController: UIPageViewController {
    var projectSettingsVC:ProjectSettingsViewController!
    var project:Project!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        projectSettingsVC = storyboard!.instantiateViewControllerWithIdentifier("projectSettingsViewController") as! ProjectSettingsViewController
        setViewControllers([projectSettingsVC], direction: .Forward, animated: false, completion: {
            finished in
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    //MARK: Hide status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}
