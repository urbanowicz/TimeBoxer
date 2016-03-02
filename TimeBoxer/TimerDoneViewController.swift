//
//  TimerDoneViewController.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 02/03/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class TimerDoneViewController: UIViewController {

    @IBOutlet weak var okButton: OKButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.seafoam()
        setupOKButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

//MARK: Setup UI elements
    private func setupOKButton() {
        okButton.borderColor = Colors.almostBlack()
        okButton.ovalLayerColor = Colors.seafoam()
        okButton.frontLayerColor = Colors.almostBlack()
        okButton.ovalLayerHighlightedColor = Colors.almostBlack()
        okButton.frontLayerHighlightedColor = Colors.seafoam()
        okButton.borderWidth = 2.0
    }
}
