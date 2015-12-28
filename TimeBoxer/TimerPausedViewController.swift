//
//  TimerPausedViewController.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 05.11.2015.
//  Copyright © 2015 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class TimerPausedViewController: UIViewController {
    @IBOutlet weak var pausedLabel: UILabel!
    @IBOutlet weak var topContainer: UIView!
    @IBOutlet weak var toolbarFiller: UIView!
    @IBOutlet weak var resumeButton: StartButton!
    @IBOutlet weak var cancelButton: CancelButton!
    @IBOutlet weak var stopButton: StopButton!
//----------------------------------------------------------------------------------------------------------------------

    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red:0.15, green:0.15, blue:0.15, alpha:1.0)
        topContainer.backgroundColor = UIColor(red:0.15, green:0.15, blue:0.15, alpha:1.0)
        toolbarFiller.backgroundColor = UIColor(red:0.15, green:0.15, blue:0.15, alpha:1.0)
        pausedLabel.textColor = UIColor(red:1.0, green:0.945, blue: 0.902, alpha:1.0)
        
        resumeButton.ovalLayerColor = UIColor(red:1.0, green:0.945, blue: 0.902, alpha:1.0)
        resumeButton.frontLayerColor = UIColor(red:0.15, green:0.15, blue:0.15, alpha:1.0)
        resumeButton.borderWidth = 0.0
        
        cancelButton.ovalLayerColor = resumeButton.ovalLayerColor
        cancelButton.frontLayerColor = resumeButton.frontLayerColor
        cancelButton.borderWidth = 0.0
        
        stopButton.ovalLayerColor = cancelButton.ovalLayerColor
        stopButton.frontLayerColor = cancelButton.frontLayerColor
        stopButton.borderWidth = 0.0
    }

//----------------------------------------------------------------------------------------------------------------------
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
    }

//----------------------------------------------------------------------------------------------------------------------
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    

//----------------------------------------------------------------------------------------------------------------------
    @IBAction func stopButtonPressed(sender: InvertedStopButton)
    {
    
    }

//----------------------------------------------------------------------------------------------------------------------
    @IBAction func cancelButtonPressed(sender: InvertedCancelButton)
    {

    }
    
//----------------------------------------------------------------------------------------------------------------------
    @IBAction func resumeButtonPressed(sender: InvertedStartButton)
    {

    }
    
    
// MARK: - Navigation
//----------------------------------------------------------------------------------------------------------------------
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if let segueIdentifier = segue.identifier {
            print(segueIdentifier)
        } else {
            print("unknown Segue ")
        }
    }
//----------------------------------------------------------------------------------------------------------------------
    


}
