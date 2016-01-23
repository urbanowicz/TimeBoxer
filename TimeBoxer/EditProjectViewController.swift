//
//  EditProjectViewController.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 07.01.2016.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class EditProjectViewController: UIViewController, UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action:"handlePan:")
        panGestureRecognizer.delegate = self
        self.view.addGestureRecognizer(panGestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: pan gesture recognizer
    func handlePan(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(self.view)
        let dx:CGFloat = (-translation.x) / (self.view.superview!.frame.width)
        let transitionManager = self.transitioningDelegate as! TransitionManager
        
        switch(recognizer.state) {
        case .Began:
            print("BEGIN")
            performSegueWithIdentifier("EditProjectUnwind", sender:self)
            break
        
        case .Changed:
            print("CHANGE")
            transitionManager.interactiveDismissAnimator!.updateInteractiveTransition(dx)
            break
        
        default:
            print(recognizer.state.rawValue)
            let interactiveDismissAnimator = transitionManager.interactiveDismissAnimator!
            if -translation.x > view.superview!.frame.width/2.0 {
                interactiveDismissAnimator.finishInteractiveTransition()
            } else {
                interactiveDismissAnimator.cancelInteractiveTransition()
            }
        }
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGeustureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGeustureRecognizer.translationInView(self.view)
            if fabs(translation.x) > fabs(translation.y) && translation.x < 0 {
                return true
            } else {
                return false
            }
        }
        return false
    }
}
