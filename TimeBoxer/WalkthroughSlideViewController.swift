//
//  WalkthtoughSlideViewController.swift
//  Walkthrough
//
//  Created by Tomasz Urbanowicz on 14/10/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class WalkthroughSlideViewController: UIViewController {
    
    private var imageView: UIImageView!
    var slideName:String!
    
    convenience init(slideName: String) {
        self.init()
        imageView = UIImageView()
        self.slideName = slideName
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        imageView.frame = CGRectMake(0, 0, screenWidth, screenHeight)
        view.addSubview(imageView)
        var slideImage = UIImage()
        switch screenWidth {
        case 320:
            slideImage = UIImage(named: "\(slideName)-320")!
        case 375:
            slideImage = UIImage(named: "\(slideName)-375")!
        case 414:
            slideImage = UIImage(named: "\(slideName)-414")!
        default:
            slideImage = UIImage(named: "\(slideName)-375")!
        }
        imageView.image = slideImage
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}