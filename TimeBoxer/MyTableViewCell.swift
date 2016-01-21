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
    var originalCenter:CGPoint?
    var segueStarted:Bool = false
    
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
    
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    //MARK: pan gesture recognizer
    
    func handlePan(recognizer: UIPanGestureRecognizer) {
        let drawerSize = CGFloat(50)
        if recognizer.state == .Began {
            print("PAN BEGAN")
            originalCenter = center
            segueStarted = false
        }
        if recognizer.state == .Changed {
            let translation = recognizer.translationInView(self.superview!)
            if translation.x < drawerSize {
                if segueStarted {
                    interactiveTransitionManager!.interactiveAnimator!.cancelInteractiveTransition()
                    segueStarted = false
                }
                center.x = originalCenter!.x + translation.x
            } else {
                if !segueStarted {
                    parentVC!.performSegueWithIdentifier("ProjectsTableToEditProject", sender: parentVC!)
                    segueStarted = true
                }
                let dx:CGFloat = (translation.x - drawerSize) / self.superview!.frame.width
                interactiveTransitionManager!.interactiveAnimator!.updateInteractiveTransition(dx)
            }
        }
        
        if recognizer.state == .Ended {
            print("PAN ENDED")
            let translation = recognizer.translationInView(self.superview!)
            if translation.x - drawerSize > (self.superview!.frame.width/2.0) {
                interactiveTransitionManager!.interactiveAnimator!.finishInteractiveTransition()
            } else {
                UIView.animateWithDuration(0.3, animations: {self.center.x = self.originalCenter!.x})
                interactiveTransitionManager!.interactiveAnimator!.cancelInteractiveTransition()
            }
            segueStarted = false
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
