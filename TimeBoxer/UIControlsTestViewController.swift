//
//  UIControlsTestViewController.swift
//  TimeBoxer
//
//  Created by Tomasz on 27/02/16.
//  Copyright © 2016 Tomasz. All rights reserved.
//

import UIKit

class UIControlsTestViewController: UIViewController {
    let blackColor = Colors.almostBlack()

    @IBOutlet weak var testLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()

    }
    
    override func viewDidAppear(animated: Bool) {
        print(testLabel.frame)
    }
    
    override func viewDidLayoutSubviews() {
        setupTestLabel()
    }
    
    private func setupTestLabel() {
        let frame = CGRectMake(0, 0, 250, 50)
        testLabel.frame = frame
        testLabel.font = testLabel.font.fontWithSize(18.0)
        testLabel.text = "Read On Intelligence "
        testLabel.numberOfLines = 0
        testLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        let width = frame.width
        var height = heightForLabel(testLabel, maxWidth: width)
        var fontSize = testLabel.font.pointSize
        while height > frame.height && fontSize > 12 {
            fontSize -= 1
            testLabel.font = testLabel.font.fontWithSize(fontSize)
            height = heightForLabel(testLabel, maxWidth: width)
        }
        print(testLabel.frame)
        print(testLabel.font.pointSize)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func heightForLabel(label:UILabel, maxWidth:CGFloat) -> CGFloat {
        let text = label.text! as NSString
        let attributes = [NSFontAttributeName: label.font]
        let frameSize = CGSizeMake(maxWidth, CGFloat.max)
        let labelSize = text.boundingRectWithSize(frameSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributes, context: nil)
        return labelSize.height
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
