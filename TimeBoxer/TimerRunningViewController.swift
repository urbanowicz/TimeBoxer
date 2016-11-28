//
//  TimerRunningViewController.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 27.10.2015.
//  Copyright © 2015 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class TimerRunningViewController: UIViewController, POPAnimationDelegate {
    @IBOutlet weak var pauseButton: PauseButton!
    var stopButton: StopButton = StopButton()
    var resumeButton: StartButton = StartButton()
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var xButton: XButton!
    
    var numberOfSecondsToCountDown = 0 //number of seconds
    var numberOfSecondsTheTimerWasSetTo = 0
    var stopTime:NSDate?
    var startTime:NSDate?
    var project: Project?
    
    private let stopTimeKey = "TimeBoxer_TimerRunningVC_StopTimeKey"
    private let timeLabelTextFormatter = TimeLabelTextFormatter()
    var timer = NSTimer()
    private var timerDoneNotification:UILocalNotification?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = Colors.slider()
        
        registerForLocalNotifications()
        setupProjectNameLabel()
        setupTimeLabel()
        setupPauseButton()
        setupStopButton()
        setupResumeButton()
        setupXButton()
    }
    

    override func viewWillAppear(animated: Bool) {
        //Make sure all buttons are enabled
        self.pauseButton.enabled = true
        self.stopButton.enabled = true
        self.resumeButton.enabled = true
        self.xButton.enabled = true
        
        
        setupStopTimeBasedOnNumberOfSecondsToCountDown()
        setupTimerDoneNotification()
        setupTimer()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//MARK: Setup UI elements
    
    private func setupProjectNameLabel() {
        projectNameLabel.textColor = Colors.almostBlack()
        projectNameLabel.text = project!.name
        projectNameLabel.numberOfLines = 4
        projectNameLabel.adjustsFontSizeToFitWidth = true
        projectNameLabel.sizeToFit()
    }
    
    private func setupTimeLabel() {
        timeLabel.textColor = Colors.almostBlack()
    }
    
    private func setupPauseButton() {
        pauseButton.borderColor = Colors.almostBlack()
        pauseButton.borderWidth = 2.0
        pauseButton.roundLayerColor = Colors.slider()
        pauseButton.frontLayerColor = Colors.almostBlack()
    }
    
    private func setupResumeButton() {
        resumeButton.borderColor = Colors.slider()
        resumeButton.borderWidth = 2.0
        resumeButton.roundLayerColor = Colors.almostBlack()
        resumeButton.frontLayerColor = Colors.slider()
        resumeButton.frame = CGRectZero
        resumeButton.alpha = 0.0
        resumeButton.addTarget(self, action: #selector(TimerRunningViewController.resumeButtonPressed), forControlEvents: .TouchDown)
        self.view.addSubview(resumeButton)
    }
    
    private func setupStopButton() {
        stopButton.borderColor = Colors.golden()
        stopButton.borderWidth = 2.0
        stopButton.roundLayerColor = Colors.almostBlack()
        stopButton.frontLayerColor = Colors.golden()
        stopButton.frame = CGRectZero
        stopButton.alpha = 0.0
        stopButton.addTarget(self, action: #selector(TimerRunningViewController.stopButtonPressed), forControlEvents: .TouchDown)
        self.view.addSubview(stopButton)
    }
    
    private func setupXButton() {
        xButton.borderWidth = 0.0
        xButton.roundLayerColor = Colors.slider()
        xButton.frontLayerColor = Colors.almostBlack()
        xButton.addTarget(self, action: #selector(TimerRunningViewController.xButtonPressed), forControlEvents: .TouchDown)
    }
    
//MARK: Actions
    func xButtonPressed() {
        //Disable buttons for the time of the animation.
        self.xButton.enabled = false
        self.pauseButton.enabled = false
        self.stopButton.enabled = false
        self.resumeButton.enabled = false
        timer.invalidate()
        removeStopTimeFromUserDefaults()
        cancelTimerDoneNotification()
        performSegueWithIdentifier("TimerRunningToTimeSlider", sender: self)
    }
    
    @IBAction func pauseButtonPressed(sender: UIButton) {
        //Stop the timer and cancel the 'Timer Done' notification
        timer.invalidate()
        removeStopTimeFromUserDefaults()
        cancelTimerDoneNotification()
        
        //Disable buttons for the time of the animation.
        //Enable them again when the animation stops
        self.pauseButton.enabled = false
        self.stopButton.enabled = false
        self.resumeButton.enabled = false
        self.xButton.enabled = false
        
        //Setup Resume button position
        let resumeButtonPositionX = pauseButton.layer.position.x - pauseButton.frame.width/2.0 - 10
        let resumeButtonPositionY = pauseButton.layer.position.y
        resumeButton.layer.position = CGPointMake(resumeButtonPositionX, resumeButtonPositionY)
        
        //Setup Stop button position
        let stopButtonPositionX = pauseButton.layer.position.x + pauseButton.frame.width/2.0 + 10
        let stopButtonPositionY = pauseButton.layer.position.y
        stopButton.layer.position = CGPointMake(stopButtonPositionX, stopButtonPositionY)
        
        //Animate the pause button
        let pauseButtonZeroSizeAnimation = POPSpringAnimation(propertyNamed: kPOPViewSize)
        pauseButtonZeroSizeAnimation.toValue = NSValue.init(CGSize: CGSizeZero)
        pauseButtonZeroSizeAnimation.springBounciness = 4
        pauseButtonZeroSizeAnimation.springSpeed = 4
        pauseButton.pop_addAnimation(pauseButtonZeroSizeAnimation, forKey: "zeroSize")
        
        let pauseButtonZeroAlphaAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        pauseButtonZeroAlphaAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pauseButtonZeroAlphaAnimation.toValue = 0.0
        pauseButtonZeroAlphaAnimation.duration = 0.2
        pauseButton.pop_addAnimation(pauseButtonZeroAlphaAnimation, forKey: "zeroAlpha")
        
        //Animate the resume button
        let pauseButtonSize = CGSizeMake(pauseButton.frame.width, pauseButton.frame.height)
        let resumeButtonScaleUpAnimation = POPSpringAnimation(propertyNamed: kPOPLayerSize)
        resumeButtonScaleUpAnimation.toValue = NSValue.init(CGSize: pauseButtonSize)
        resumeButtonScaleUpAnimation.springBounciness = 4
        resumeButtonScaleUpAnimation.springSpeed = 4
        resumeButtonScaleUpAnimation.delegate = self
        resumeButton.layer.pop_addAnimation(resumeButtonScaleUpAnimation, forKey: "scaleUp")
        
        let resumeButtonAlphaAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        resumeButtonAlphaAnimation.toValue = 1.0
        resumeButtonAlphaAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        resumeButtonAlphaAnimation.duration = 0.2
        resumeButton.pop_addAnimation(resumeButtonAlphaAnimation, forKey: "alpha")
        
        //Animate the stop button
        let stopButtonScaleUpAnimation = POPSpringAnimation(propertyNamed: kPOPLayerSize)
        stopButtonScaleUpAnimation.toValue = NSValue.init(CGSize: pauseButtonSize)
        stopButtonScaleUpAnimation.springBounciness = 4
        stopButtonScaleUpAnimation.springSpeed = 4
        stopButton.layer.pop_addAnimation(stopButtonScaleUpAnimation, forKey: "scaleUp")
        
        let stopButtonAlphaAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        stopButtonAlphaAnimation.toValue = 1.0
        stopButtonAlphaAnimation.timingFunction = CAMediaTimingFunction(name:
        kCAMediaTimingFunctionEaseInEaseOut)
        stopButtonAlphaAnimation.duration = 0.2
        stopButton.pop_addAnimation(stopButtonAlphaAnimation, forKey: "alpha")
        
        //Animate the time Label
        let timeLabelColorAnimation = POPBasicAnimation(propertyNamed: kPOPLabelTextColor)
        timeLabelColorAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        timeLabelColorAnimation.toValue = Colors.silver()
        timeLabelColorAnimation.duration = 0.2
        timeLabel.pop_addAnimation(timeLabelColorAnimation, forKey: "textColor")
        
        let timeLabelScaleDownAnimation = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
        timeLabelScaleDownAnimation.toValue = NSValue.init(CGPoint: CGPointMake(0.5, 0.5))
        timeLabelScaleDownAnimation.springSpeed = 4
        timeLabelScaleDownAnimation.springBounciness = 4
        timeLabel.pop_addAnimation(timeLabelScaleDownAnimation, forKey: "scaleDown")
        
        //Animate the project name label
        let projectNameLabelColorAnimation = POPBasicAnimation(propertyNamed: kPOPLabelTextColor)
        projectNameLabelColorAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        projectNameLabelColorAnimation.toValue = Colors.silver()
        projectNameLabelColorAnimation.duration = 0.2
        projectNameLabel.pop_addAnimation(projectNameLabelColorAnimation, forKey: "textColor")
        
        let projectNameLabelScaleDownAnimation = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
        projectNameLabelScaleDownAnimation.toValue = NSValue.init(CGPoint: CGPointMake(0.5, 0.5))
        projectNameLabelScaleDownAnimation.springSpeed = 4
        projectNameLabelScaleDownAnimation.springBounciness = 4
        projectNameLabel.pop_addAnimation(projectNameLabelScaleDownAnimation, forKey: "scaleDown")
        
        //Animate the x button
        let xButtonRoundLayerFillColorAnimation = POPBasicAnimation(propertyNamed: kPOPShapeLayerFillColor)
        xButtonRoundLayerFillColorAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        xButtonRoundLayerFillColorAnimation.toValue = Colors.almostBlack()
        xButtonRoundLayerFillColorAnimation.duration = 0.2
        xButton.layer.pop_addAnimation(xButtonRoundLayerFillColorAnimation, forKey: "fillColor")
        
        let xButtonFrontLayerFillColorAnimation = POPBasicAnimation(propertyNamed: kPOPShapeLayerFillColor)
        xButtonFrontLayerFillColorAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        xButtonFrontLayerFillColorAnimation.toValue = Colors.silver()
        xButtonFrontLayerFillColorAnimation.duration = 0.2
        xButton.frontLayer.pop_addAnimation(xButtonFrontLayerFillColorAnimation, forKey: "fillColor")
        
        //Animate the background color
        let backgroundColorAnimation = POPBasicAnimation(propertyNamed: kPOPViewBackgroundColor)
        backgroundColorAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        backgroundColorAnimation.toValue = Colors.almostBlack()
        backgroundColorAnimation.duration = 0.2
        view.pop_addAnimation(backgroundColorAnimation, forKey: "backgroundColor")
    }
    
    func resumeButtonPressed() {
        
        //Disable buttons for the time of the animation.
        //Enable them again when the animation stops
        self.pauseButton.enabled = false
        self.stopButton.enabled = false
        self.resumeButton.enabled = false
        self.xButton.enabled = false
        
        //Animate the project name label
        let projectNameLabelColorAnimation = POPBasicAnimation(propertyNamed: kPOPLabelTextColor)
        projectNameLabelColorAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        projectNameLabelColorAnimation.toValue = Colors.almostBlack()
        projectNameLabelColorAnimation.duration = 0.2
        projectNameLabel.pop_addAnimation(projectNameLabelColorAnimation, forKey: "textColor")
        
        let projectNameLabelScaleUpAnimation = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
        projectNameLabelScaleUpAnimation.toValue = NSValue.init(CGPoint: CGPointMake(1.0, 1.0))
        projectNameLabelScaleUpAnimation.springSpeed = 4
        projectNameLabelScaleUpAnimation.springBounciness = 4
        projectNameLabel.pop_addAnimation(projectNameLabelScaleUpAnimation, forKey: "scaleUp")
        
        //Animate the time label
        let timeLabelColorAnimation = POPBasicAnimation(propertyNamed: kPOPLabelTextColor)
        timeLabelColorAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        timeLabelColorAnimation.toValue = Colors.almostBlack()
        timeLabelColorAnimation.duration = 0.2
        timeLabel.pop_addAnimation(timeLabelColorAnimation, forKey: "textColor")
        
        let timeLabelScaleUpAnimation = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
        timeLabelScaleUpAnimation.toValue = NSValue.init(CGPoint: CGPointMake(1.0, 1.0))
        timeLabelScaleUpAnimation.springSpeed = 4
        timeLabelScaleUpAnimation.springBounciness = 4
        timeLabel.pop_addAnimation(timeLabelScaleUpAnimation, forKey: "scaleUp")
        
        //Animate the pause button
        let originalSize = CGSizeMake(resumeButton.bounds.width, resumeButton.bounds.width)
        let pauseButtonScaleUpAnimation = POPSpringAnimation(propertyNamed: kPOPViewSize)
        pauseButtonScaleUpAnimation.toValue = NSValue.init(CGSize: originalSize)
        pauseButtonScaleUpAnimation.springBounciness = 4
        pauseButtonScaleUpAnimation.springSpeed = 4
        pauseButtonScaleUpAnimation.delegate = self
        pauseButton.pop_addAnimation(pauseButtonScaleUpAnimation, forKey: "scaleUp")
        
        let pauseButtonAlphaAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        pauseButtonAlphaAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pauseButtonAlphaAnimation.toValue = 1.0
        pauseButtonAlphaAnimation.duration = 0.2
        pauseButton.pop_addAnimation(pauseButtonAlphaAnimation, forKey: "alpha")
        
        //Animate the resume button
        let resumeButtonZeroSizeAnimation = POPSpringAnimation(propertyNamed: kPOPLayerSize)
        resumeButtonZeroSizeAnimation.toValue = NSValue.init(CGSize: CGSizeZero)
        resumeButtonZeroSizeAnimation.springBounciness = 4
        resumeButtonZeroSizeAnimation.springSpeed = 4
        resumeButton.layer.pop_addAnimation(resumeButtonZeroSizeAnimation, forKey: "zeroSize")
        
        let resumeButtonZeroAlphaAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        resumeButtonZeroAlphaAnimation.toValue = 0.0
        resumeButtonZeroAlphaAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        resumeButtonZeroAlphaAnimation.duration = 0.2
        resumeButton.pop_addAnimation(resumeButtonZeroAlphaAnimation, forKey: "zeroAlpha")
        
        //Animate the stop button
        let stopButtonZeroSizeAnimation = POPSpringAnimation(propertyNamed: kPOPLayerSize)
        stopButtonZeroSizeAnimation.toValue = NSValue.init(CGSize: CGSizeZero)
        stopButtonZeroSizeAnimation.springBounciness = 4
        stopButtonZeroSizeAnimation.springSpeed = 4
        stopButton.layer.pop_addAnimation(stopButtonZeroSizeAnimation, forKey: "zeroSize")
        
        let stopButtonZeroAlphaAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        stopButtonZeroAlphaAnimation.toValue = 0.0
        stopButtonZeroAlphaAnimation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        stopButtonZeroAlphaAnimation.duration = 0.2
        stopButton.pop_addAnimation(stopButtonZeroAlphaAnimation, forKey: "zeroAlpha")
        
        //Animate the x button
        let xButtonRoundLayerFillColorAnimation = POPBasicAnimation(propertyNamed: kPOPShapeLayerFillColor)
        xButtonRoundLayerFillColorAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        xButtonRoundLayerFillColorAnimation.toValue = Colors.slider()
        xButtonRoundLayerFillColorAnimation.duration = 0.2
        xButton.layer.pop_addAnimation(xButtonRoundLayerFillColorAnimation, forKey: "fillColor")
        
        let xButtonFrontLayerFillColorAnimation = POPBasicAnimation(propertyNamed: kPOPShapeLayerFillColor)
        xButtonFrontLayerFillColorAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        xButtonFrontLayerFillColorAnimation.toValue = Colors.almostBlack()
        xButtonFrontLayerFillColorAnimation.duration = 0.2
        xButton.frontLayer.pop_addAnimation(xButtonFrontLayerFillColorAnimation, forKey: "fillColor")

        //Animate the background color
        let backgroundColorAnimation = POPBasicAnimation(propertyNamed: kPOPViewBackgroundColor)
        backgroundColorAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        backgroundColorAnimation.toValue = Colors.slider()
        backgroundColorAnimation.duration = 0.2
        view.pop_addAnimation(backgroundColorAnimation, forKey: "backgroundColor")
        
        //Kick off the timer and register the 'Timer Done' notification
        setupStopTimeBasedOnNumberOfSecondsToCountDown()
        setupTimerDoneNotification()
        setupTimer()
    }
    
    func stopButtonPressed() {
        //Disable buttons for the time of the animation.
        self.pauseButton.enabled = false
        self.stopButton.enabled = false
        self.resumeButton.enabled = false
        self.xButton.enabled = false
        handleTimerDone()
    }

    func countDown() {
        numberOfSecondsToCountDown = Int(stopTime!.timeIntervalSinceNow)
        numberOfSecondsToCountDown = numberOfSecondsToCountDown < 0 ? 0 : numberOfSecondsToCountDown
        timeLabel.text = timeLabelTextFormatter.formatWithNumberOfSecondsToCountDown(numberOfSecondsToCountDown)
        if numberOfSecondsToCountDown == 0 {
            removeStopTimeFromUserDefaults()
            cancelTimerDoneNotification()
            handleTimerDone()
        }
    }

//MARK: Notificatios
    private func handleTimerDone() {
        timer.invalidate()
        performSegueWithIdentifier("TimerRunningToTimerDone", sender: self)
    }

    private func registerForLocalNotifications() {
        let types: UIUserNotificationType = [.Badge, .Sound, .Alert]
        let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    }
    
    private func setupStopTimeBasedOnNumberOfSecondsToCountDown() {
        stopTime = NSCalendar.gmtCalendar().dateByAddingUnit(NSCalendarUnit.Second, value: numberOfSecondsToCountDown, toDate: NSDate(), options: NSCalendarOptions())
        NSUserDefaults.standardUserDefaults().setObject(stopTime, forKey: stopTimeKey)
    }
    
    private func setupTimerDoneNotification() {
        //schedule Notification
        timerDoneNotification = UILocalNotification()
        timerDoneNotification!.fireDate = stopTime
        timerDoneNotification!.alertBody = "Timer done."
        //timerDoneNotification!.soundName = UILocalNotificationDefaultSoundName
        timerDoneNotification!.soundName = "ring.caf"
        UIApplication.sharedApplication().scheduleLocalNotification(timerDoneNotification!)
    }
    
    private func setupTimer() {
        timeLabel.text = timeLabelTextFormatter.formatWithNumberOfSecondsToCountDown(numberOfSecondsToCountDown)
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target:self, selector: #selector(TimerRunningViewController.countDown),
                                                       userInfo: nil, repeats: true)
    }
    
    private func removeStopTimeFromUserDefaults() {
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: stopTimeKey)
    }
    
    private func cancelTimerDoneNotification() {
        if let notification = timerDoneNotification {
            UIApplication.sharedApplication().cancelLocalNotification(notification)
            timerDoneNotification = nil 
        }
    }
    
    func pop_animationDidStop(anim: POPAnimation!, finished: Bool) {
        //Pause button had been pressed and the animation stopped
        //Or the resume button had been  pressed and the animation stopped
        //Either way, enable all th buttons now.
        xButton.enabled = true
        resumeButton.enabled = true
        stopButton.enabled = true
        pauseButton.enabled = true
    }
    
//MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        removeStopTimeFromUserDefaults()
        cancelTimerDoneNotification()
        
        if let segueIdentifier = segue.identifier {
            
            if segueIdentifier == "TimerRunningToTimeSlider" {
                let timeSliderVC = segue.destinationViewController as! TimeSliderViewController
                timeSliderVC.project = project
                return 
            }
            
            if segueIdentifier == "TimerRunningToTimerDone" {
                let timerDoneVC = segue.destinationViewController as! TimerDoneViewController
                timerDoneVC.numberOfSecondsTheTimerWasSetTo = numberOfSecondsTheTimerWasSetTo
                timerDoneVC.numberOfSecondsToCountDown = numberOfSecondsToCountDown
                timerDoneVC.projectName = project!.name
                timerDoneVC.project = project
                timerDoneVC.startTime = startTime
            }
        }
    }

    override func showViewController(vc: UIViewController, sender: AnyObject?) {
        let containerVC = parentViewController as! ImprovedContainerViewController
        if vc as? TimeSliderViewController != nil {
            containerVC.popViewController(FadeInAnimator())
            return
        }
        
        if vc as? TimerDoneViewController != nil {
            containerVC.replaceViewController(withVC: vc, animator: FadeInAnimator())
        }
    }
//MARK: Disable auto rotate
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
}
