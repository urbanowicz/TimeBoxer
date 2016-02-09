//
//  MyTableViewCell.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 19/01/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    var transitionManager:TransitionManager?
    var parentVC:UIViewController?
    var originalCenter:CGPoint?
    var project:Project?
    var segueStarted:Bool = false
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style:UITableViewCellStyle.Value1, reuseIdentifier:reuseIdentifier)
        
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
            originalCenter = center
            segueStarted = false
        }
        if recognizer.state == .Changed {
            let translation = recognizer.translationInView(self.superview!)
            if translation.x < drawerSize {
                if segueStarted {
                    transitionManager!.interactiveAnimator!.cancelInteractiveTransition()
                    segueStarted = false
                }
                center.x = originalCenter!.x + translation.x
            } else {
                if !segueStarted {
                    parentVC!.performSegueWithIdentifier("ProjectsTableToEditProject", sender: self)
                    segueStarted = true
                }
                let dx:CGFloat = (translation.x - drawerSize) / self.superview!.frame.width
                transitionManager!.interactiveAnimator!.updateInteractiveTransition(dx)
            }
        }
        if recognizer.state == .Ended {
            if !segueStarted {
                UIView.animateWithDuration(0.2, animations: {self.center.x = self.originalCenter!.x})
            } else {
                let translation = recognizer.translationInView(self.superview!)
                if translation.x - drawerSize > (self.superview!.frame.width/2.0) {
                    transitionManager!.interactiveAnimator!.finishInteractiveTransition()
                } else {
                    transitionManager!.interactiveAnimator!.cancelInteractiveTransition()
                    
                    
                }
                UIView.animateWithDuration(0.1, animations: {self.center.x = self.originalCenter!.x})
                segueStarted = false
            }
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
