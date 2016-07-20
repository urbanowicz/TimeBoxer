//
//  TimerRunningViewController.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 27.10.2015.
//  Copyright © 2015 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class TimerRunningViewController: UIViewController {
    @IBOutlet weak var pauseButton: PauseButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var projectNameLabel: UILabel!
    
    var numberOfSecondsToCountDown = 0 //number of seconds
    var numberOfSecondsTheTimerWasSetTo = 0
    var stopTime:NSDate?
    var project: Project?
    
    private let stopTimeKey = "TimeBoxer_TimerRunningVC_StopTimeKey"
    private let toTimerPausedAnimator = ToTimerPausedAnimator()
    private let timeLabelTextFormatter = TimeLabelTextFormatter()
    var timer = NSTimer()
    private var timerDoneNotification:UILocalNotification?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = Colors.silver()
        
        registerForLocalNotifications()
        attemptReadingNumberOfSecondsToCountDownFromUserDefaults()
        setupProjectNameLabel()
        setupTimeLabel()
        setupPauseButton()
    }
    

    override func viewWillAppear(animated: Bool) {
        if stopTime == nil {
            setupStopTimeBasedOnNumberOfSecondsToCountDown()
            setupTimerDoneNotification()
        }
        
        timeLabel.text = timeLabelTextFormatter.formatWithNumberOfSecondsToCountDown(numberOfSecondsToCountDown)
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target:self, selector: #selector(TimerRunningViewController.countDown),
            userInfo: nil, repeats: true)
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
        pauseButton.ovalLayerColor = Colors.silver()
        pauseButton.frontLayerColor = Colors.almostBlack()
        pauseButton.ovalLayerHighlightedColor = Colors.almostBlack()
        pauseButton.frontLayerHighlightedColor = Colors.silver()
        pauseButton.borderWidth = 2.0
    }
    
//MARK: Actions
    @IBAction func pauseButtonPressed(sender: UIButton) {
        timer.invalidate()
        performSegueWithIdentifier("TimerRunningToTimerPaused", sender: sender)
    }

    func countDown() {
        numberOfSecondsToCountDown = Int(stopTime!.timeIntervalSinceNow)
        numberOfSecondsToCountDown = numberOfSecondsToCountDown < 0 ? 0 : numberOfSecondsToCountDown
        timeLabel.text = timeLabelTextFormatter.formatWithNumberOfSecondsToCountDown(numberOfSecondsToCountDown)
        if numberOfSecondsToCountDown == 0 {
            handleTimerDone()
        }
    }
    
    private func handleTimerDone() {
        timer.invalidate()
        performSegueWithIdentifier("TimerRunningToTimerDone", sender: self)
    }
    
//MARK: Notificatios
    private func registerForLocalNotifications() {
        let types: UIUserNotificationType = [.Badge, .Sound, .Alert]
        let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    }
    
    private func attemptReadingNumberOfSecondsToCountDownFromUserDefaults() {
        stopTime = NSUserDefaults.standardUserDefaults().objectForKey(stopTimeKey) as? NSDate
        if stopTime != nil {
            numberOfSecondsToCountDown = Int(stopTime!.timeIntervalSinceNow)
        }
    }
    
    private func setupStopTimeBasedOnNumberOfSecondsToCountDown() {
        stopTime = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Second, value: numberOfSecondsToCountDown, toDate: NSDate(), options: NSCalendarOptions())
        NSUserDefaults.standardUserDefaults().setObject(stopTime, forKey: stopTimeKey)
    }
    
    private func setupTimerDoneNotification() {
        //schedule Notification
        timerDoneNotification = UILocalNotification()
        timerDoneNotification!.fireDate = stopTime
        timerDoneNotification!.alertBody = "Timer done."
        timerDoneNotification!.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(timerDoneNotification!)
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
    
//MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        removeStopTimeFromUserDefaults()
        cancelTimerDoneNotification()
        
        if let segueIdentifier = segue.identifier {
            if segueIdentifier == "TimerRunningToTimerPaused" {
                let timerPausedVC = segue.destinationViewController as! TimerPausedViewController
                timerPausedVC.numberOfSecondsToCountDown = numberOfSecondsToCountDown
                timerPausedVC.numberOfSecondsTheTimerWasSetTo = numberOfSecondsTheTimerWasSetTo
                timerPausedVC.project = project
                return
            }
            if segueIdentifier == "TimerRunningToTimerDone" {
                let timerDoneVC = segue.destinationViewController as! TimerDoneViewController
                timerDoneVC.numberOfSecondsTheTimerWasSetTo = numberOfSecondsTheTimerWasSetTo
                timerDoneVC.numberOfSecondsToCountDown = 0
                timerDoneVC.projectName = project!.name
                timerDoneVC.project = project
            }
        }
    }

    override func showViewController(vc: UIViewController, sender: AnyObject?) {
        let containerVC = parentViewController as! ContainerViewController
        if  sender as? PauseButton != nil {
            containerVC.switchViewControllers(self, toVC: vc, animator: toTimerPausedAnimator)
            return
        }
        if sender as? TimerRunningViewController != nil {
            containerVC.switchViewControllers(self, toVC: vc, animator: FadeInAnimator())
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


//
// MARK: - ToTimerPausedAnimator
//
private class ToTimerPausedAnimator: NSObject, Animator {
    let transitionDuration = 0.25
    var timerRunningVC:TimerRunningViewController?
    var timerPausedVC:TimerPausedViewController?
    var container:UIView?
    var completionBlock:(()->Void)?

//----------------------------------------------------------------------------------------------------------------------
    func animateTransition(fromVC: UIViewController, toVC: UIViewController, container: UIView, completion: (() -> Void)?)
    {
        //Remember: container is the view of the parent controller. It already contains the
        //fromVC.view
        //It is the animator's responsibility to remove the fromVC.view from the container and
        //add the toVC.view to the container
        
        //1. Store the function parameters as instance variables
        self.timerRunningVC = fromVC as? TimerRunningViewController
        self.timerPausedVC = toVC as? TimerPausedViewController
        self.container = container
        self.completionBlock = completion
        
        //2. Crete the expanding circle animation layer and set it as a mask layer of the toVC.view
        let expandingCircleAnimationLayer = prepareExpandingCircleAnimationLayer()
        toVC.view.layer.mask = expandingCircleAnimationLayer
        container.addSubview(toVC.view)
    }

//----------------------------------------------------------------------------------------------------------------------
    override func animationDidStop(anim: CAAnimation, finished flag: Bool)
    {
        //Done with the animation, do the final cleanup
        timerPausedVC!.view.layer.mask = nil
        timerRunningVC!.view.removeFromSuperview()
        if let executeCompletionBlock = completionBlock {
            executeCompletionBlock()
        }
    }
    
//----------------------------------------------------------------------------------------------------------------------
    private func prepareExpandingCircleAnimationLayer() -> CALayer
    {
        let animationLayer = CAShapeLayer()
        //Create the small circle path and the large circle path
        let pauseButton = timerRunningVC!.pauseButton
        let pauseButtonCenter:CGPoint = container!.convertPoint(pauseButton.center, fromView: pauseButton.superview)
        let smallCirclePath = CirclePathWrapper(centerX: pauseButtonCenter.x, centerY: pauseButtonCenter.y,
            radius: pauseButton.radius).path
        let largeCirclePath = createLargeCircleForButton(pauseButton).path
        animationLayer.path = largeCirclePath
        
        //Create the animation
        let animation = CABasicAnimation(keyPath: "path")
        animation.delegate = self
        animation.duration = transitionDuration
        animation.fromValue = smallCirclePath
        animation.toValue = largeCirclePath
        animationLayer.addAnimation(animation, forKey: "path")
        return animationLayer
    }
//----------------------------------------------------------------------------------------------------------------------
    private func createLargeCircleForButton(button:AbstractOvalButton) -> CirclePathWrapper
    {
        let circleCenter:CGPoint = container!.convertPoint(button.center, fromView: button.superview)
        let xs = circleCenter.x
        let ys = circleCenter.y
        let x0 = container!.frame.origin.x
        let y0 = container!.frame.origin.y
        let  largeRadius = sqrt(pow((xs - x0),2) + pow((ys - y0),2))
        return CirclePathWrapper(centerX: xs, centerY: ys, radius: largeRadius)
    }
}
