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
    @IBOutlet weak var totalHoursTodayLabel: UILabel!
    @IBOutlet weak var daysSinceStartLabel: UILabel!
    @IBOutlet weak var paceThisWeekLabel: UILabel!
    @IBOutlet weak var lastWorkedOnLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPanGestureRecognizer()
        setupTitleBar()
    }
    
    override func viewWillAppear(animated: Bool) {
        //projectNameLabel.text = project!.name
        setupStartedOnLabel()
        setupTotalHoursLabel()
        setupTotalHoursTodayLabel()
        setupDaysSinceStartLabel()
        setupPaceThisWeekLabel()
        setupLastWorkedOnLabel()
        
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
    
    private func setupTotalHoursTodayLabel() {
        totalHoursTodayLabel.text = "Total Hours Today : Todo"
    }
    
    private func setupDaysSinceStartLabel() {
        let daysSinceStartString = NSMutableAttributedString(string: "Days since start: ", attributes: avenirAttributesForRegularText())
        let numberOfDaysString = NSAttributedString(string: String(project!.daysSinceStart()), attributes: avenirAttributesForMarkedText())
        daysSinceStartString.appendAttributedString(numberOfDaysString)
        daysSinceStartLabel.attributedText = daysSinceStartString
    }
    
    private func setupPaceThisWeekLabel() {
        let paceString = NSMutableAttributedString(string: "Pace last seven days: ", attributes: avenirAttributesForRegularText())
        let valueString = NSAttributedString(string: String(project!.averagePaceLastSevenDays()), attributes: avenirAttributesForMarkedText())
        paceString.appendAttributedString(valueString)
        paceThisWeekLabel.attributedText = paceString
    }
    
    private func setupLastWorkedOnLabel() {
        let lastWorkedOnString = NSMutableAttributedString(string: "Last worked on: ", attributes: avenirAttributesForRegularText())
        let valueString = NSAttributedString(string: String(lastWorkedOnDateFormatter.formatLastWorkedOnString(project!.lastWrokedOn())), attributes: avenirAttributesForMarkedText())
        lastWorkedOnString.appendAttributedString(valueString)
        lastWorkedOnLabel.attributedText = lastWorkedOnString
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
