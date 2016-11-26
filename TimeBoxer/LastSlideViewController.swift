//
//  LastSlideViewController.swift
//  TimeBoxer
//
//  Created by Tomasz on 29/10/16.
//  Copyright © 2016 Tomasz. All rights reserved.
//

import UIKit

class LastSlideViewController: WalkthroughSlideViewController {
    let okButton = OKButton()
    var delegate:LastSlideDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOKButton()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupOKButton() {
        okButton.frontLayerColor = Colors.silver()
        okButton.frontLayerStrokeColor = Colors.silver()
        okButton.frontLayerHighlighteStrokeColor = Colors.silver()
        okButton.ovalLayerColor = Colors.almostBlack()
        okButton.ovalLayerHighlightedColor = Colors.almostBlack()
        okButton.borderColor = Colors.silver()
        okButton.borderWidth = 2.0
        okButton.addTarget(self, action: #selector(okButtonPressed), forControlEvents: .TouchUpInside)
        
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        let buttonSize = CGSizeMake(0.28 * screenWidth, 0.28*screenWidth)
        let buttonOrigin = CGPointMake(screenWidth/2.0 - buttonSize.width/2.0, screenHeight - (buttonSize.height + 20))
        okButton.frame = CGRect(origin: buttonOrigin, size: buttonSize)
        view.insertSubview(okButton, aboveSubview: self.imageView)
    }

    func okButtonPressed(sender: UIButton) {
        //prevent the ok button from being pressed multiple times
        okButton.enabled = false
        delegate?.okButtonPressed()
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
