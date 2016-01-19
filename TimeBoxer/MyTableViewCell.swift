//
//  MyTableViewCell.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 19/01/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    var interactiveTransitionManager:TransitionManager?
    var parentVC:UIViewController?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style:style, reuseIdentifier:reuseIdentifier)
        
        let recognizer = UIPanGestureRecognizer(target:self, action:"handlePan:")
        recognizer.delegate = self
        self.addGestureRecognizer(recognizer)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: pan gesture recognizer
    
    func handlePan(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .Began {
            print("PAN BEGAN")
             parentVC!.performSegueWithIdentifier("ProjectsTableToEditProject", sender: parentVC!)
        }
        if recognizer.state == .Changed {
            print("PAN CHANGED")
            let translation = recognizer.translationInView(self.superview!)
            let dx:CGFloat = translation.x / self.superview!.frame.width
            interactiveTransitionManager!.interactiveAnimator?.updateInteractiveTransition(dx)
        }
        
        if recognizer.state == .Ended {
            print("PAN ENDED")
            interactiveTransitionManager!.interactiveAnimator!.finishInteractiveTransition()
        }
    }
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translationInView(self.superview!)
            if fabs(translation.x) > fabs(translation.y) && translation.x > 0 {
                return true
            }
            return false
        }
        return false
    }

}
