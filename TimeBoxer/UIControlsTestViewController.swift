//
//  UIControlsTestViewController.swift
//  TimeBoxer
//
//  Created by Tomasz on 27/02/16.
//  Copyright © 2016 Tomasz. All rights reserved.
//

import UIKit

class UIControlsTestViewController: UIViewController {
    let blackColor = UIColor(red: 0.153, green: 0.153, blue: 0.153, alpha: 1.0)
    @IBOutlet weak var startButton: StartButton!
    
    @IBOutlet weak var slider: BigSlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = blackColor
        setupSlider()
        setupStartButton()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupSlider() {
        slider.fillColor = UIColor.blueColor()
    }
    
    private func setupStartButton() {
        startButton.borderColor = UIColor.whiteColor()
        startButton.ovalLayerColor = blackColor
        startButton.frontLayerColor = UIColor.whiteColor()
        startButton.ovalLayerHighlightedColor = UIColor.whiteColor()
        startButton.frontLayerHighlightedColor = blackColor;
        startButton.borderWidth = 5.0
    }
    
    @IBAction func startButtonPressed(sender: StartButton) {
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
