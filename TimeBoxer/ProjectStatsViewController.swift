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
    
    @IBOutlet weak var projectNameLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.almostBlack()
        setupProjectNameLabel()

    }
    
    override func viewWillAppear(animated: Bool) {
        projectNameLabel.text = project!.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Setup UI Elements

    private func setupProjectNameLabel() {
        projectNameLabel.font = UIFont(name: "Avenir Book", size: 16)
        projectNameLabel.textColor = Colors.silver()
    }
    
}
