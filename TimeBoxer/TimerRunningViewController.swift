//
//  TimerRunningViewController.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 27.10.2015.
//  Copyright © 2015 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class TimerRunningViewController: UIViewController {
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var toolbarFiller: UIView!
    @IBOutlet weak var topContainer: UIView!
    
    var timer = NSTimer()
    var counter = 0 //number of seconds
    
//----------------------------------------------------------------------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red:1.0, green:0.945, blue: 0.902, alpha:1.0)
        toolbarFiller.backgroundColor = view.backgroundColor
        topContainer.backgroundColor = view.backgroundColor
    }
    
//----------------------------------------------------------------------------------------------------------------------
    override func viewWillAppear(animated: Bool) {
        updateTimeLabel()
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target:self, selector: "countDown",
            userInfo: nil, repeats: true)
    }

//----------------------------------------------------------------------------------------------------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//----------------------------------------------------------------------------------------------------------------------
    @IBAction func pauseButtonPressed(sender: UIButton) {
        timer.invalidate()
    }
    
//----------------------------------------------------------------------------------------------------------------------
    func countDown() {
        counter--
        updateTimeLabel()
        if counter == 0 {
            //initiate the segue programatically
            //stopButtonPressed(stopButton)
        }
    }
    
//----------------------------------------------------------------------------------------------------------------------
    private func updateTimeLabel() {
        var counterCopy = counter
        let hours = counterCopy / 3600
        counterCopy = counterCopy % 3600
        let minutes = counterCopy / 60
        counterCopy = counterCopy % 60
        let seconds = counterCopy
        
        var timeText = "\(hours):"
        if minutes == 0 {
            timeText += "00:"
        } else {
            if minutes < 10 {
                timeText += "0"
            }
            timeText += "\(minutes):"
        }
        if seconds == 0 {
            timeText += "00"
        } else {
            if seconds < 10 {
                timeText += "0"
            }
            timeText += "\(seconds)"
        }
        
        timeLabel.text = timeText
        
    }
    
    //MARK: - Navigation
//----------------------------------------------------------------------------------------------------------------------
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let segueIdentifier = segue.identifier {
            if segueIdentifier == "timerRunningVCToTimerPausedVC" {

            }
            print(segueIdentifier)
        } else {
            print ("unknown segue")
        }
    }
    
//----------------------------------------------------------------------------------------------------------------------
    @IBAction func unwindToTimerRunningVC (segue: UIStoryboardSegue) {
        if let segueIdentifier = segue.identifier {
            print(segueIdentifier)
        } else {
            print ("unknown segue")
        }
    }

}
