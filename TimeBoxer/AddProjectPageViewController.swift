//
//  AddProjectPageViewController.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 30/08/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class AddProjectPageViewController: UIPageViewController, AddProjectPageDelegate, SetDailyGoalPageDelegate {
    var chooseProjectNameVC:AddProjectViewController!
    var setDailyGoalViewController:SetDailyGoalViewController!
    var trainDelegate:AddProjectTrainDelegate?
    
    private var projectName:String?
    private var dailyGoalSeconds:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chooseProjectNameVC = storyboard!.instantiateViewControllerWithIdentifier("addProjectViewController") as! AddProjectViewController
        chooseProjectNameVC.delegate = self
        self.setViewControllers([chooseProjectNameVC], direction: .Forward, animated: false,
        completion: {
            finished in
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: AddProjectPageDelegate
    func nextButtonPressed() {
        setDailyGoalViewController = storyboard!.instantiateViewControllerWithIdentifier("setDailyGoalViewController") as!
            SetDailyGoalViewController
        setDailyGoalViewController.delegate = self
        self.setViewControllers([setDailyGoalViewController], direction: .Forward, animated: true, completion:
            {
            finished in
        })
    }
    
    func didChooseProjectName(projectName: String) {
        self.projectName = projectName
    }
    
    //MARK: SetDailyGoalPageDelegate
    func didPressBackButton() {
        self.setViewControllers([chooseProjectNameVC], direction: .Reverse , animated: true,
                completion: {
                finished in
        })
    }
    func didSetDailyGoal(dailyGoalSeconds: Int) {
        self.dailyGoalSeconds = dailyGoalSeconds
        let newProject = Project(projectName: self.projectName!, startDate: NSDate())
        trainDelegate?.didAddNewProject(newProject)
    }
    
    //MARK: Disable auto rotate
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    //MARK: Hide status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
