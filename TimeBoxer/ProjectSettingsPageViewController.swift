//
//  ProjectSettingsPageViewController.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 14/09/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class ProjectSettingsPageViewController: UIPageViewController, ProjectSettingsPageDelegate, SettingModifierDelegate {
    var projectSettingsVC:ProjectSettingsViewController!
    var project:Project!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        projectSettingsVC = storyboard!.instantiateViewControllerWithIdentifier("projectSettingsViewController") as! ProjectSettingsViewController
        projectSettingsVC.delegate = self
        projectSettingsVC.project = project
        setViewControllers([projectSettingsVC], direction: .Forward, animated: false, completion: {
            finished in
        })
    }
    
    func didPressEditProjectName() {
        let editProjectNameVC = storyboard!.instantiateViewControllerWithIdentifier("editProjectNameVC") as! EditProjectNameViewController
        editProjectNameVC.delegate = self
        editProjectNameVC.project = project
        setViewControllers([editProjectNameVC], direction: .Forward, animated: true, completion: {finished in})
        
    }
    
    func didPressChangeDailyGoal() {
        let changeDailyGoalVC = storyboard!.instantiateViewControllerWithIdentifier("changeDailyGoalVC") as! ChangeDailyGoalViewController
        changeDailyGoalVC.delegate = self
        changeDailyGoalVC.project = project 
        setViewControllers([changeDailyGoalVC], direction: .Forward, animated: true, completion: {finished in})
    }
    
    func didPressDeleteProject() {
        let deleteProjectVC = storyboard!.instantiateViewControllerWithIdentifier("deleteProjectVC") as!
            DeleteProjectViewController
        deleteProjectVC.delegate = self
        setViewControllers([deleteProjectVC], direction: .Forward, animated: true, completion: {finished in})
    }
    
    func didCancelEditing(sender: UIViewController) {
        setViewControllers([projectSettingsVC], direction: .Reverse, animated: true, completion: {
            finished in
        })
    }
    
    func didCommitEditing(sender: UIViewController) {
        projectSettingsVC.projectNameLabel.text = project.name
        setViewControllers([projectSettingsVC], direction: .Reverse, animated: true, completion: {
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
