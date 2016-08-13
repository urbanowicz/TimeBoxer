//
//  EditProjectViewController.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 07.01.2016.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class ProjectStatsViewController: UIViewController, CalendarHeatMapDelegate {
    var project:Project?
    var segueStarted:Bool = false
    
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var calendarHeatMap: CalendarHeatMap!
    
    @IBOutlet weak var topBar: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.almostBlack()
        setupTopBar()
        setupProjectNameLabel()
        
        //calendarHeatMap is set in viewWillAppear because we need to configure it per each time the view appears.
    }
    
    override func viewWillAppear(animated: Bool) {
        projectNameLabel.text = project?.name
        if project != nil {
            setupCalendarHeatMap()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Setup UI Elements
    
    private func setupTopBar() {
        topBar.backgroundColor = Colors.almostBlack()
    }

    private func setupProjectNameLabel() {
        projectNameLabel.font = UIFont(name: "Avenir-Medium", size: 16)
        projectNameLabel.textColor = Colors.silver()
        projectNameLabel.numberOfLines = 2
        projectNameLabel.backgroundColor = Colors.almostBlack()
    }
    
    private func setupCalendarHeatMap() {
        calendarHeatMap.backgroundColor = Colors.almostBlack()
        let calendarHeatMapDataSource = ProjectBasedCalendarHeatMapDataSource()
        calendarHeatMapDataSource.project = project 
        calendarHeatMap.dataSource = calendarHeatMapDataSource
        calendarHeatMap.delegate = self
    }
    
    func transitionAnimationStarted() {

    }
    
    func transitionAnimationEnded() {

    }
    
}
