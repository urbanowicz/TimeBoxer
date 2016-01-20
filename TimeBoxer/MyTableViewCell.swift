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
            print(center.x)
             originalCenter = center
             //parentVC!.performSegueWithIdentifier("ProjectsTableToEditProject", sender: parentVC!)
        }
        if recognizer.state == .Changed {
            let translation = recognizer.translationInView(self.superview!)
            
            if (translation.x < 50) {
                center.x = originalCenter!.x + translation.x
                print(center.x)
            } else {
                let dx:CGFloat = translation.x / self.superview!.frame.width
            }
            //interactiveTransitionManager!.interactiveAnimator?.updateInteractiveTransition(dx)
        }
        
        if recognizer.state == .Ended {
            print("PAN ENDED")
            //interactiveTransitionManager!.interactiveAnimator!.finishInteractiveTransition()
            UIView.animateWithDuration(0.3, animations: {self.center.x = self.originalCenter!.x})
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
