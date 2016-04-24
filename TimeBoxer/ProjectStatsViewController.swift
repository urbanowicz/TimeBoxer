//
//  EditProjectViewController.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 07.01.2016.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class ProjectStatsViewController: UIViewController {
    var project:Project? 
    var segueStarted:Bool = false
    
    @IBOutlet weak var statsTableView: UITableView!
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var titleBarSeparator: UIView!
    
    let statsTableDataSource = StatsTableDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.almostBlack()
        setupStatsTableView()
        setupProjectNameLabel()
        setupTitleBarSeparator()
    }
    
    override func viewWillAppear(animated: Bool) {
        statsTableDataSource.project = project
//        statsTableView!.reloadRowsAtIndexPaths([NSIndexPath(forItem:0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
        statsTableView!.reloadData()
        adjustFontSizeForProjectNameLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Setup UI Elements
    private func setupStatsTableView() {
        statsTableView.backgroundColor = Colors.almostBlack()
        statsTableView.dataSource = statsTableDataSource
        statsTableView.rowHeight = 400
        statsTableView.separatorColor = Colors.silver()
    }
    
    private func setupProjectNameLabel() {
        projectNameLabel.font = UIFont(name: "Avenir Book", size: 16)
        projectNameLabel.textColor = Colors.silver()
    }
    
    private func adjustFontSizeForProjectNameLabel() {
        projectNameLabel.text = project!.name
        projectNameLabel.numberOfLines = 0
        projectNameLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        let (_,  numberOfLines) = projectNameLabel.heightAndNumberOfLinesWithWidth(projectNameLabel.frame.width)
        if numberOfLines >= 2 {
            projectNameLabel.font = projectNameLabel.font.fontWithSize(14.0)
        }

    }
    
    private func setupTitleBarSeparator() {
        titleBarSeparator.backgroundColor = Colors.silver()
    }
    
}
