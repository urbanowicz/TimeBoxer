//
//  UIControlsTestViewController.swift
//  TimeBoxer
//
//  Created by Tomasz on 27/02/16.
//  Copyright © 2016 Tomasz. All rights reserved.
//

import UIKit

class UIControlsTestViewController: UIViewController {
    let blackColor = Colors.toUIColor(.ALMOST_BLACK)!
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
        slider.fillColor = Colors.toUIColor(.AZURE)!
        slider.addTarget(self, action: "sliderValueChanged", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    private func setupStartButton() {
        startButton.borderColor = UIColor.whiteColor()
        startButton.ovalLayerColor = blackColor
        startButton.frontLayerColor = UIColor.whiteColor()
        startButton.ovalLayerHighlightedColor = UIColor.whiteColor()
        startButton.frontLayerHighlightedColor = blackColor;
        startButton.borderWidth = 2.0
    }
    
    func sliderValueChanged() {
        
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
