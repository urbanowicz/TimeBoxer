//
//  EditProjectViewController.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 07.01.2016.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class EditProjectViewController: UIViewController, UIGestureRecognizerDelegate {
    var project:Project?
    var segueStarted:Bool = false
    private var lastWorkedOnDateFormatter = LastWorkedOnDateFormatter()
    @IBOutlet weak var titleBar: TitleBar!
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var startedOnLabel: UILabel!
    @IBOutlet weak var totalHoursLabel: UILabel!
    

    @IBOutlet weak var daysSinceStartLabel: UILabel!
    @IBOutlet weak var averagePaceLabel: UILabel!
    
    @IBOutlet weak var lastWorkedOn: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPanGestureRecognizer()
        setupTitleBar()
    }
    
    override func viewWillAppear(animated: Bool) {
        //1.
        //projectNameLabel.text = project!.name
        setupStartedOnLabel()
        setupTotalHoursLabel()
//        
//        //3.
//        func prepareDaysSinceStartLabel() {
//            self.daysSinceStartLabel.text = "Days since start: " + String(project!.daysSinceStart())
//        }
//        prepareDaysSinceStartLabel()
//        
//        //4. Total Work Time
//        let totalWorkTimeInSconds = project!.totalSeconds()
//        let totalWorkTimeInHours = Double(totalWorkTimeInSconds / 3600).roundToPlaces(1)
//        totalWorkTimeLabel.text = "total hours: \(totalWorkTimeInHours)"
//        //5. Average pace
//        averagePaceLabel.text = "Average pace last seven days: \(project!.averagePaceLastSevenDays())"
//        
//        
//        //6.
//        self.lastWorkedOn.text = "Last worked on: " + lastWorkedOnDateFormatter.formatLastWorkedOnString(project!.lastWrokedOn())
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Setup UI Elements
    private func setupTitleBar() {
        titleBar.fillColor = Colors.violet()
    }
    
    private func setupStartedOnLabel() {
        let startedOnString = NSMutableAttributedString(string: "Started On: ", attributes:avenirAttributesForRegularText())
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        let dateString = NSAttributedString(string: dateFormatter.stringFromDate(project!.startDate), attributes: avenirAttributesForMarkedText())
        
        startedOnString.appendAttributedString(dateString)
        startedOnLabel.attributedText = startedOnString
    }
    
    private func setupTotalHoursLabel() {
        let totalSeconds = project!.totalSeconds()
        let totalHours = Double(totalSeconds / 3600).roundToPlaces(1)
        let totalHoursString = NSMutableAttributedString(string: "\(totalHours) ", attributes: avenirAttributesForMarkedText())
        var hoursString = NSAttributedString(string: " hours total", attributes: avenirAttributesForRegularText())
        if totalHours == 1 {
            hoursString = NSAttributedString(string: " hour total", attributes: avenirAttributesForRegularText())
        }
        totalHoursString.appendAttributedString(hoursString)
        self.totalHoursLabel.attributedText = totalHoursString
    }
    
    private func avenirAttributesForRegularText() -> [String : AnyObject] {
        let regularAvenirAttributes = [NSFontAttributeName:UIFont(name:"Avenir", size:18.0)!, NSForegroundColorAttributeName:Colors.almostBlack()]
        return regularAvenirAttributes
    }
    
    private func avenirAttributesForMarkedText() -> [String: AnyObject] {
        let avenirMediumFontAttributes = [UIFontDescriptorNameAttribute:"Avenir", UIFontDescriptorFaceAttribute:"Medium"]
        let avenirMediumFont = UIFont(descriptor: UIFontDescriptor(fontAttributes: avenirMediumFontAttributes), size: 18)
        let markedAttributes = [NSFontAttributeName:avenirMediumFont, NSForegroundColorAttributeName:Colors.violet()]
        return markedAttributes
    }
    
    //MARK: pan gesture recognizer
    private func setupPanGestureRecognizer() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action:"handlePan:")
        panGestureRecognizer.delegate = self
        self.view.addGestureRecognizer(panGestureRecognizer)
    }
    func handlePan(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(self.view)
        let dx:CGFloat = (-translation.x) / (self.view.frame.width)
        let transitionManager = self.transitioningDelegate as! TransitionManager
        
        switch(recognizer.state) {
        case .Began:
            print("BEGIN Gesture")
            segueStarted = true
            performSegueWithIdentifier("EditProjectUnwind", sender:self)
            break
        
        case .Changed:
            transitionManager.interactiveDismissAnimator!.updateInteractiveTransition(dx)
            break
        
        default:
            
            let interactiveDismissAnimator = transitionManager.interactiveDismissAnimator!
            if -translation.x > self.view.frame.width/2.0 {
                interactiveDismissAnimator.finishInteractiveTransition()
                print("END Gesture finish")
            } else {
                interactiveDismissAnimator.cancelInteractiveTransition()
                print("END Gesture cancel")
            }
            segueStarted = false
        }
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGeustureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGeustureRecognizer.translationInView(self.view)
            if fabs(translation.x) > fabs(translation.y) && translation.x < 0 && !segueStarted {
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("BEGIN Segue")
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}
