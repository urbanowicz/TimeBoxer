//
//  TimerPausedViewController.swift
//  TimeBoxer_v0
//
//  Created by Tomasz on 05.11.2015.
//  Copyright © 2015 Tomasz. All rights reserved.
//

import UIKit

class TimerPausedViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    var timeText = ""
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        timeLabel.text = timeText
        timeLabel.adjustsFontSizeToFitWidth = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func stopButtonPressed(sender: InvertedStopButton) {
    
    }
    @IBAction func cancelButtonPressed(sender: InvertedCancelButton) {

    }

    @IBAction func resumeButtonPressed(sender: InvertedStartButton) {

    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let segueIdentifier = segue.identifier {
            print(segueIdentifier)
        } else {
            print("unknownSegue ")
        }
    }

}
