//
//  ProjectsTableViewController.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 07.01.2016.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class ProjectsTableViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var timeBoxerLabel: UILabel!
    @IBOutlet weak var titleBarSeparator: UIView!
    @IBOutlet weak var projectsTableView: UITableView!
    @IBOutlet weak var addProjectButton: AddButton!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var noProjectsLabel: UILabel!
    @IBOutlet weak var useAddButtonLabel: UILabel!
    
    let projectsTableDataSource = ProjectsTableViewDataSource()
    private var lastWorkedOnDateFormatter = LastWorkedOnDateFormatter()
    private var newProjectAdded:Bool = false
    
    private var originalFrames = [(view:UIView, frame:CGRect)]()
    private var originalContentOffset:CGFloat?
    private var selectedCell: MyTableViewCell?
    
    private var projectNameLabelHeightConstraint:NSLayoutConstraint?
    private var projectNameLabelWidthConstraint:NSLayoutConstraint?
    private var originalProjectNameLabelTopConstraintConstant = CGFloat(0)
    private var originalProjectNameLabelLeadingConstraintConstant = CGFloat(0)
    private var startDeleteProjectButtonFrame = CGRectZero
    private var startCancelButtonFrame = CGRectZero
    private var endProjectNameLabelFrame = CGRectZero
    private var endDeleteProjectButtonFrame = CGRectZero
    private var endCancelButtonFrame = CGRectZero
    
    let transitionManager =
    TransitionManager(animator: ProjectsTableToAddProjectAnimator(),
        dismissAnimator:AddProjectToProjectsTableDismissAnimator())

    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup UI elements
        let longPressGestureRecognizer = UILongPressGestureRecognizer()
        view.addGestureRecognizer(longPressGestureRecognizer)
        longPressGestureRecognizer.addTarget(self, action: #selector(handleLongPressGesture(_:)))
        view.backgroundColor = Colors.almostBlack()
        setupAddProjectButton()
        setupProjectsTable()
        setupAppTitleLabel()
        setupTitleBarSeparator()
        setupNoProjectsLabel()
        setupUseAddButtonLabel()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(animated: Bool) {
        if !newProjectAdded {
            if projectsTableDataSource.numberOfProjects() == 0 {
                noProjectsLabel.hidden = false
                useAddButtonLabel.hidden = false
                stackView.hidden = false
                projectsTableView.hidden = true
                titleBarSeparator.hidden = true
                timeBoxerLabel.hidden = true
            } else {
                noProjectsLabel.hidden = true
                useAddButtonLabel.hidden = true
                stackView.hidden = true
                projectsTableView.hidden = false
                titleBarSeparator.hidden = false
                timeBoxerLabel.hidden = false
                projectsTableView.reloadData()
            }
        } else {
            noProjectsLabel.hidden = true
            useAddButtonLabel.hidden = true
            stackView.hidden = true 
            projectsTableView.hidden = false
            titleBarSeparator.hidden = false
            timeBoxerLabel.hidden = false 
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if newProjectAdded {
            let index = NSIndexPath(forItem:0, inSection: 0)
            projectsTableView.beginUpdates()
            projectsTableView.insertRowsAtIndexPaths([index],
                withRowAnimation: UITableViewRowAnimation.Top)
            projectsTableView.endUpdates()
            newProjectAdded = false
        }
    }
    
    //MARK: Setup UI Elements
    
    private func setupProjectsTable() {
        projectsTableDataSource.projectsTableViewController = self
        projectsTableView.delegate = self
        projectsTableView.backgroundColor = Colors.almostBlack()
        projectsTableView.dataSource = projectsTableDataSource
        projectsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    private func setupAppTitleLabel() {
        timeBoxerLabel.textColor = Colors.azure()
    }
    
    private func setupAddProjectButton() {
        addProjectButton.borderWidth = 0.0
        addProjectButton.roundLayerColor = Colors.silver()
        addProjectButton.frontLayerColor = Colors.almostBlack()

    }
    
    private func setupNoProjectsLabel() {
        noProjectsLabel.textColor = Colors.silver()
        noProjectsLabel.numberOfLines = 2
        noProjectsLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
    }
    
    private func setupUseAddButtonLabel() {
        useAddButtonLabel.textColor = Colors.lightGray()
        useAddButtonLabel.numberOfLines = 2
        useAddButtonLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
    }
    
    private func setupTitleBarSeparator() {
        titleBarSeparator.backgroundColor = Colors.veryLightGray().withAlpha(0.1)
    }
    
    func cellAtPoint(point:CGPoint) -> MyTableViewCell? {
        if let index = projectsTableView.indexPathForRowAtPoint(point) {
            return projectsTableView.cellForRowAtIndexPath(index) as? MyTableViewCell
        } else  {
            return nil
        }
    }
    
    func handleLongPressGesture(gestureRecognizer:UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .Began {
            
            selectedCell = self.cellAtPoint(gestureRecognizer.locationInView(self.projectsTableView))
            if selectedCell == nil {
                return
            }
            
            selectedCell!.setupDeleteProjectButton()
            selectedCell!.deleteProjectButton.addTarget(self, action: #selector(ProjectsTableViewController.deleteProjectButtonPressed), forControlEvents: .TouchDown)
            selectedCell!.setupCancelButton()
            selectedCell!.cancelButton.addTarget(self, action: #selector(ProjectsTableViewController.cancelButtonPressed), forControlEvents: .TouchDown)
            
            //----------------HELPER FUNCTIONS-------------------------------------------------
            func backupTupleForView(uiViewInstance: UIView) -> (view: UIView,frame: CGRect) {
                let frameCopy = CGRectMake(uiViewInstance.frame.origin.x,
                                           uiViewInstance.frame.origin.y,
                                           uiViewInstance.frame.width,
                                           uiViewInstance.frame.height)
                return (uiViewInstance, frameCopy)
            }

            
            func prepareStartAndEndFrames() {
                let projectNameLabel = selectedCell!.projectNameLabel
                let deleteProjectButton = selectedCell!.deleteProjectButton
                let cancelButton = selectedCell!.cancelButton
                let spacing = CGFloat(20)
                let stackWidth = projectNameLabel.frame.width
                let stackHeight = projectNameLabel.frame.height + deleteProjectButton.frame.height + cancelButton.frame.height + 2*spacing
                let stackX = view.frame.width / 2.0 - stackWidth / 2.0
                let stackY = view.frame.height / 2.0 - stackHeight / 2.0
                
                endProjectNameLabelFrame = CGRectMake(stackX, stackY, stackWidth, projectNameLabel.frame.height)
                endDeleteProjectButtonFrame =
                    CGRectMake(stackX, endProjectNameLabelFrame.origin.y + endProjectNameLabelFrame.height + spacing, 170, deleteProjectButton.frame.height)
                endCancelButtonFrame =
                    CGRectMake(stackX, endDeleteProjectButtonFrame.origin.y + endDeleteProjectButtonFrame.height + spacing, 170, cancelButton.frame.height)
                
                startDeleteProjectButtonFrame = CGRectMake(view.frame.width/2.0, endDeleteProjectButtonFrame.origin.y + endDeleteProjectButtonFrame.height/2.0
                    ,0,0)
                
                startCancelButtonFrame = CGRectMake(view.frame.width/2.0, endCancelButtonFrame.origin.y+endCancelButtonFrame.height/2.0, 0, 0)
            }
            //----------------------------------------------------------------------------------
            
            NSLayoutConstraint.deactivateConstraints([self.selectedCell!.projectNameLabelBottomToFacadeViewTopConstraint,self.selectedCell!.projectNameLabelTrailingSpaceToFacadeViewConstraint])
            
            projectNameLabelHeightConstraint = NSLayoutConstraint(item: selectedCell!.projectNameLabel, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0, constant: selectedCell!.projectNameLabel.frame.height)
            projectNameLabelHeightConstraint!.active = true
            
            projectNameLabelWidthConstraint = NSLayoutConstraint(item: selectedCell!.projectNameLabel, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0, constant: selectedCell!.projectNameLabel.frame.width)
            projectNameLabelWidthConstraint!.active = true
            
            
            self.originalProjectNameLabelTopConstraintConstant = selectedCell!.projectNameLabelTopToFacadeViewConstraint.constant
            self.originalProjectNameLabelLeadingConstraintConstant = selectedCell!.projectNameLabelLeadingSpaceToFacadeViewConstraint.constant
            
            prepareStartAndEndFrames()
            
            
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut,
                animations: {
                    
                    //1. Move the header up
                    let moveUpAmmount = self.view.convertPoint(self.selectedCell!.frame.origin, fromView: self.projectsTableView).y
                    self.originalFrames.append(backupTupleForView(self.timeBoxerLabel))
                    self.timeBoxerLabel.frame.origin.y -= moveUpAmmount
                    self.timeBoxerLabel.alpha = 0.0
                    
                    self.originalFrames.append(backupTupleForView(self.titleBarSeparator))
                    self.titleBarSeparator.frame.origin.y -= moveUpAmmount
                    self.titleBarSeparator.alpha = 0.0
                    
                    
                    //2. Move the add project button down
                    let moveDownAmount = self.view.frame.height - (moveUpAmmount + self.selectedCell!.frame.height)
                    self.originalFrames.append(backupTupleForView(self.addProjectButton))
                    self.addProjectButton.frame.origin.y += moveDownAmount
                    self.addProjectButton.alpha = 0.0
                    
                    //3. Make the project table fill the whole container view
                    self.originalFrames.append(backupTupleForView(self.projectsTableView))
                    self.originalContentOffset = self.projectsTableView.contentOffset.y
                    self.projectsTableView.setContentOffset(CGPoint(x:0, y:0), animated: false)
                    self.projectsTableView.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)

                    
                    //4. Move the visible cell out of the way
                    for visibleCell in self.projectsTableView.visibleCells {
                        if visibleCell.frame.origin.y < self.selectedCell!.frame.origin.y {
                            self.originalFrames.append(backupTupleForView(visibleCell))
                            visibleCell.frame.origin.y -= self.selectedCell!.frame.origin.y
                            visibleCell.alpha = 0.0
                        }
                        
                        if visibleCell.frame.origin.y > self.selectedCell?.frame.origin.y {
                            self.originalFrames.append(backupTupleForView(visibleCell))
                            visibleCell.frame.origin.y += self.view.frame.height - (self.selectedCell!.frame.origin.y + self.selectedCell!.frame.height)
                            visibleCell.alpha = 0.0
                        }
                    }

                    //5. Expand the cell itself
                    self.originalFrames.append(backupTupleForView(self.selectedCell!))
                    self.selectedCell!.frame = CGRect(x: 0, y: 0, width: self.projectsTableView.frame.width, height: self.projectsTableView.frame.height)
                    
                    
                    //6. Move the projectNameLabel to the center
                    self.selectedCell!.projectNameLabelTopToFacadeViewConstraint.constant = self.endProjectNameLabelFrame.origin.y
                    self.selectedCell!.projectNameLabelLeadingSpaceToFacadeViewConstraint.constant = self.endProjectNameLabelFrame.origin.x
                    //7. Fade out the background of the table view
                    self.view.layoutIfNeeded()
                },
                completion: {
                    finished in
                    
                    let deleteProjectButton = self.selectedCell!.deleteProjectButton
                    let scaleUpDeleteProjectButtonAnimation = POPSpringAnimation(propertyNamed: kPOPViewSize)
                    scaleUpDeleteProjectButtonAnimation.toValue = NSValue.init(CGSize: self.endDeleteProjectButtonFrame.size)
                    scaleUpDeleteProjectButtonAnimation.springBounciness = 4
                    scaleUpDeleteProjectButtonAnimation.springSpeed = 10
                    deleteProjectButton.pop_addAnimation(scaleUpDeleteProjectButtonAnimation, forKey: "scaleUp")
                    
                    let deleteProjectButtonAlphaAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
                    deleteProjectButtonAlphaAnimation.toValue = 1.0
                    deleteProjectButtonAlphaAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                    deleteProjectButtonAlphaAnimation.duration = 0.2
                    deleteProjectButton.pop_addAnimation(deleteProjectButtonAlphaAnimation, forKey: "alpha")
                    
                    
                    let cancelButton = self.selectedCell!.cancelButton
                    let scaleUpCancelButtonAnimation = POPSpringAnimation(propertyNamed: kPOPViewSize)
                    scaleUpCancelButtonAnimation.toValue = NSValue.init(CGSize: self.endCancelButtonFrame.size)
                    scaleUpCancelButtonAnimation.springBounciness = 4
                    scaleUpCancelButtonAnimation.springSpeed = 10
                    cancelButton.pop_addAnimation(scaleUpCancelButtonAnimation, forKey: "scaleUp")
                    
                    let cancelButtonAlphaAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
                    cancelButtonAlphaAnimation.toValue = 1.0
                    cancelButtonAlphaAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                    cancelButtonAlphaAnimation.duration = 0.2
                    cancelButton.pop_addAnimation(deleteProjectButtonAlphaAnimation, forKey: "alpha")
                    
                    let facadeView = self.selectedCell!.facadeView
                    deleteProjectButton.frame = self.startDeleteProjectButtonFrame
                    cancelButton.frame = self.startCancelButtonFrame
                    deleteProjectButton.alpha = 0.0
                    cancelButton.alpha = 0.0
                    facadeView.addSubview(deleteProjectButton)
                    facadeView.addSubview(cancelButton)

            })
        }
    }
    
    func deleteProjectButtonPressed() {
        selectedCell!.setupConfirmDeleteLabel()
        let confirmDeleteLabel = selectedCell!.confirmDeleteLabel
        let confirmDeleteLabelPositionX = selectedCell!.deleteProjectButton.layer.position.x
        let confirmDeleteLabelPositionY = selectedCell!.deleteProjectButton.layer.position.y
        confirmDeleteLabel.layer.position.y = confirmDeleteLabelPositionY
        confirmDeleteLabel.layer.position.x = confirmDeleteLabelPositionX + self.view.frame.width
        selectedCell!.addSubview(confirmDeleteLabel)
        
        selectedCell!.setupYesDeleteButton()
        let yesDeleteButton = selectedCell!.yesDeleteButton
        let yesDeleteButtonPositionY = selectedCell!.cancelButton.layer.position.y
        let yesDeleteButtonPositionX = selectedCell!.cancelButton.frame.origin.x + yesDeleteButton.frame.width / 2.0
        yesDeleteButton.layer.position.x = yesDeleteButtonPositionX + self.view.frame.width
        yesDeleteButton.layer.position.y = yesDeleteButtonPositionY
        yesDeleteButton.addTarget(self, action: #selector(ProjectsTableViewController.yesDeleteButtonPressed), forControlEvents: .TouchDown)
        selectedCell!.addSubview(yesDeleteButton)

        
        selectedCell!.setupNoDeleteButton()
        let noDeleteButton = selectedCell!.noDeleteButton
        let noDeleteButtonPositionX = selectedCell!.cancelButton.frame.origin.x +
            selectedCell!.cancelButton.frame.width - noDeleteButton.frame.width/2.0
        let noDeleteButtonPositionY = selectedCell!.cancelButton.layer.position.y
        noDeleteButton.layer.position.y = noDeleteButtonPositionY
        noDeleteButton.layer.position.x = noDeleteButtonPositionX + self.view.frame.width
        noDeleteButton.addTarget(self, action: #selector(ProjectsTableViewController.noDeleteButtonPressed), forControlEvents: .TouchDown)
        selectedCell!.addSubview(noDeleteButton)
        
        
        let confirmDeleteLabelSlideInFromRightAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPosition)
        confirmDeleteLabelSlideInFromRightAnimation.toValue = NSValue.init(CGPoint: CGPoint(x: confirmDeleteLabelPositionX, y: confirmDeleteLabelPositionY))
        confirmDeleteLabelSlideInFromRightAnimation.springSpeed = 4
        confirmDeleteLabelSlideInFromRightAnimation.springBounciness = 4
        confirmDeleteLabel.layer.pop_addAnimation(confirmDeleteLabelSlideInFromRightAnimation, forKey: "slideInFromRight")
        
        let yesButtonSlideInFromRightAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPosition)
        yesButtonSlideInFromRightAnimation.toValue = NSValue.init(CGPoint: CGPoint(x: yesDeleteButtonPositionX, y: yesDeleteButtonPositionY))
        yesButtonSlideInFromRightAnimation.springSpeed = 4
        yesButtonSlideInFromRightAnimation.springBounciness = 4
        yesDeleteButton.layer.pop_addAnimation(yesButtonSlideInFromRightAnimation, forKey: "slideInFromRight")
        
        
        let noButtonSlideInFromRightAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPosition)
        noButtonSlideInFromRightAnimation.toValue = NSValue.init(CGPoint: CGPoint(x: noDeleteButtonPositionX, y: noDeleteButtonPositionY))
        noButtonSlideInFromRightAnimation.springSpeed = 4
        noButtonSlideInFromRightAnimation.springBounciness = 4
        noDeleteButton.layer.pop_addAnimation(noButtonSlideInFromRightAnimation, forKey: "slideInFromRight")
        
        
        let deleteButton = selectedCell!.deleteProjectButton
        let deleteButtonPositionX = deleteButton.layer.position.x
        let deleteButtonSlideOutLeftAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionX)
        deleteButtonSlideOutLeftAnimation.toValue = deleteButtonPositionX - self.view.frame.width
        deleteButtonSlideOutLeftAnimation.springSpeed = 4
        deleteButtonSlideOutLeftAnimation.springBounciness = 4
        deleteButton.layer.pop_addAnimation(deleteButtonSlideOutLeftAnimation, forKey: "slideOutLeft")
        
        let cancelButton = selectedCell!.cancelButton
        let cancelButtonPositionX = cancelButton.layer.position.x
        let cancelButtonSlideOutLeftAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionX)
        cancelButtonSlideOutLeftAnimation.toValue = cancelButtonPositionX - self.view.frame.width
        cancelButtonSlideOutLeftAnimation.springSpeed = 4
        cancelButtonSlideOutLeftAnimation.springBounciness = 4
        cancelButton.layer.pop_addAnimation(cancelButtonSlideOutLeftAnimation, forKey: "slideOutLeft")

    }
    
    func yesDeleteButtonPressed() {
        let fadeOutAnimation = CABasicAnimation(keyPath: "opacity")
        fadeOutAnimation.fromValue = 1.0
        fadeOutAnimation.toValue = 0.0
        fadeOutAnimation.duration = 0.2
        fadeOutAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let scaleDownAnimation = CABasicAnimation(keyPath: "transform")
        
        scaleDownAnimation.fromValue = NSValue(CATransform3D: CATransform3DIdentity)
        let scaleDownTransform = CATransform3DMakeScale(0.0, 0.0, 1)
        scaleDownAnimation.toValue = NSValue(CATransform3D: scaleDownTransform)
        scaleDownAnimation.duration = 0.2
        scaleDownAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let dismissAnimationGroup = CAAnimationGroup()
        dismissAnimationGroup.animations = [fadeOutAnimation, scaleDownAnimation]
        dismissAnimationGroup.duration = 0.2
        dismissAnimationGroup.delegate = self
        
        let confirmDeleteLabel = selectedCell!.confirmDeleteLabel
        let yesDeleteButton = selectedCell!.yesDeleteButton
        let noDeleteButton = selectedCell!.noDeleteButton

        confirmDeleteLabel.layer.addAnimation(dismissAnimationGroup, forKey: "dismiss")
        yesDeleteButton.layer.addAnimation(dismissAnimationGroup, forKey: "dismiss")
        dismissAnimationGroup.setValue(true, forKey: "isFinal")
        noDeleteButton.layer.addAnimation(dismissAnimationGroup, forKey: "dismiss")
        
        func setFinalTransformAndOpacityForView(someView:UIView) {
            someView.layer.transform = scaleDownTransform
            someView.layer.opacity = 0
        }
        
        setFinalTransformAndOpacityForView(confirmDeleteLabel)
        setFinalTransformAndOpacityForView(yesDeleteButton)
        setFinalTransformAndOpacityForView(noDeleteButton)
        
    }
    
    
    func noDeleteButtonPressed() {
        
        //Slide the delete button back from the left
        let deleteButton = selectedCell!.deleteProjectButton
        let deleteButtonPositionX = deleteButton.layer.position.x
        let deleteButtonSlideInFromLeftAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionX)
        deleteButtonSlideInFromLeftAnimation.toValue = deleteButtonPositionX + self.view.frame.width
        deleteButtonSlideInFromLeftAnimation.springBounciness = 4
        deleteButtonSlideInFromLeftAnimation.springSpeed = 4
        deleteButton.layer.pop_addAnimation(deleteButtonSlideInFromLeftAnimation, forKey: "slideInFromLeft")
        
        //Slide the cancel button back from the left
        let cancelButton = selectedCell!.cancelButton
        let cancelButtonPositionX = cancelButton.layer.position.x
        let cancelButtonSlideInFromLeftAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionX)
        cancelButtonSlideInFromLeftAnimation.toValue = cancelButtonPositionX + self.view.frame.width
        cancelButtonSlideInFromLeftAnimation.springBounciness = 4
        cancelButtonSlideInFromLeftAnimation.springSpeed = 4
        cancelButton.layer.pop_addAnimation(cancelButtonSlideInFromLeftAnimation, forKey: "slideInFromLeft")
        

        //Slide the confirmDeleteLabel out to the right
        let confirmDeleteLabel = selectedCell!.confirmDeleteLabel
        let confirmDeleteLabelPositionX = confirmDeleteLabel.layer.position.x
        let confirmDeleteLabelSlideOutRightAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionX)
        confirmDeleteLabelSlideOutRightAnimation.toValue = confirmDeleteLabelPositionX + self.view.frame.width
        confirmDeleteLabelSlideOutRightAnimation.springBounciness = 4
        confirmDeleteLabelSlideOutRightAnimation.springSpeed = 4
        confirmDeleteLabel.layer.pop_addAnimation(confirmDeleteLabelSlideOutRightAnimation, forKey: "slideOutRight")
        
        //Slide the yesDeleteButton out to the right
        let yesDeleteButton = selectedCell!.yesDeleteButton
        let yesDeleteButtonPositionX = yesDeleteButton.layer.position.x
        let yesButtonSliedOutRightAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionX)
        yesButtonSliedOutRightAnimation.toValue = yesDeleteButtonPositionX + self.view.frame.width
        yesButtonSliedOutRightAnimation.springBounciness = 4
        yesButtonSliedOutRightAnimation.springSpeed = 4
        yesDeleteButton.layer.pop_addAnimation(yesButtonSliedOutRightAnimation, forKey: "slideOutRight")
        
        //Slide the noDeleteButton out to the right
        let noDeleteButton = selectedCell!.noDeleteButton
        let noDeleteButtonPositionX = noDeleteButton.layer.position.x
        let noButtonSliedOutRightAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionX)
        noButtonSliedOutRightAnimation.toValue = noDeleteButtonPositionX + self.view.frame.width
        noButtonSliedOutRightAnimation.springBounciness = 4
        noButtonSliedOutRightAnimation.springSpeed = 4
        noDeleteButton.layer.pop_addAnimation(noButtonSliedOutRightAnimation, forKey: "slideOutRight")
    }
    
    func cancelButtonPressed() {
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.selectedCell!.deleteProjectButton.alpha = 0.0
            self.selectedCell!.deleteProjectButton.frame = self.startDeleteProjectButtonFrame
            self.selectedCell!.cancelButton.alpha = 0.0
            self.selectedCell!.cancelButton.frame = self.startCancelButtonFrame
            
            self.view.layoutIfNeeded()
            },
           completion: {
            finished in
            self.selectedCell!.deleteProjectButton.removeFromSuperview()
            self.selectedCell!.cancelButton.removeFromSuperview()
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut,
                animations: {
                    for (uiView, frame) in self.originalFrames {
                        uiView.frame = frame
                        uiView.alpha = 1.0
                    }
                    self.projectsTableView.setContentOffset(CGPoint(x:0, y: self.originalContentOffset!), animated: false)
                    self.selectedCell!.facadeView.backgroundColor = Colors.almostBlack()
                    self.selectedCell!.projectNameLabelLeadingSpaceToFacadeViewConstraint.constant = self.originalProjectNameLabelLeadingConstraintConstant
                    self.selectedCell!.projectNameLabelTopToFacadeViewConstraint.constant = self.originalProjectNameLabelTopConstraintConstant
                    self.projectsTableView.backgroundColor = Colors.almostBlack()
                    self.view.layoutIfNeeded()
                    
                },
                completion: {
                    finished in
                    
                    NSLayoutConstraint.activateConstraints ([self.selectedCell!.projectNameLabelBottomToFacadeViewTopConstraint,self.selectedCell!.projectNameLabelTrailingSpaceToFacadeViewConstraint])
                    NSLayoutConstraint.deactivateConstraints([self.projectNameLabelHeightConstraint!, self.projectNameLabelWidthConstraint!])
                    self.originalFrames.removeAll()
            })
        })
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if let isFinal = anim.valueForKey("isFinal")  {
            if isFinal as! Bool == true {
                selectedCell!.deleteProjectButton.removeFromSuperview()
                selectedCell!.cancelButton.removeFromSuperview()
                selectedCell!.yesDeleteButton.removeFromSuperview()
                selectedCell!.noDeleteButton.removeFromSuperview()
                selectedCell!.confirmDeleteLabel.removeFromSuperview()
                
                UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut,
                    animations: {
                        for (uiView, frame) in self.originalFrames {
                            uiView.frame = frame
                            uiView.alpha = 1.0
                        }
                        self.projectsTableView.setContentOffset(CGPoint(x:0, y: self.originalContentOffset!), animated: false)
                        self.selectedCell!.facadeView.backgroundColor = Colors.almostBlack()
                        self.selectedCell!.projectNameLabelLeadingSpaceToFacadeViewConstraint.constant = self.originalProjectNameLabelLeadingConstraintConstant
                        self.selectedCell!.projectNameLabelTopToFacadeViewConstraint.constant = self.originalProjectNameLabelTopConstraintConstant
                        self.projectsTableView.backgroundColor = Colors.almostBlack()
                        self.view.layoutIfNeeded()

                    },
                    completion: {
                        finished in
                        NSLayoutConstraint.activateConstraints ([self.selectedCell!.projectNameLabelBottomToFacadeViewTopConstraint,self.selectedCell!.projectNameLabelTrailingSpaceToFacadeViewConstraint])
                        NSLayoutConstraint.deactivateConstraints([self.projectNameLabelHeightConstraint!, self.projectNameLabelWidthConstraint!])
                        self.originalFrames.removeAll()
                        self.projectsTableView.beginUpdates()
                        let selectedCellIndexPath = self.projectsTableView.indexPathForCell(self.selectedCell!)!
                        self.projectsTableView.deleteRowsAtIndexPaths([selectedCellIndexPath], withRowAnimation: .Fade)
                        self.projectsTableDataSource.deleteProject(self.selectedCell!.project!.name)
                        self.projectsTableView.endUpdates()
                })

                
                
            }
        }
    }
    
//MARK: handle table select
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! MyTableViewCell
        let facadeView = cell.facadeView
        let shakeAnimation = CAKeyframeAnimation(keyPath: "position.x")
        
        shakeAnimation.values = [0, 30, 0, -30, 0]
        shakeAnimation.keyTimes = [0.0, 1.0/4.0, 2.0/4.0 , 3.0/4.0, 1.0]
        shakeAnimation.duration = 0.6
        shakeAnimation.additive = true
        shakeAnimation.removedOnCompletion = true
        
        facadeView.layer.addAnimation(shakeAnimation, forKey: "shake")
    }

    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {

    }
    
//MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == "ProjectsTableToAddProject" {
            segue.destinationViewController.transitioningDelegate = transitionManager
        }
    }
    
    @IBAction func unwindToProjectsTableVC(unwindSegue: UIStoryboardSegue) {
        let addProjectVC:AddProjectViewController = unwindSegue.sourceViewController as! AddProjectViewController
        let newProjectName = addProjectVC.projectNameTextField!.text!
        let newProject = Project(projectName: newProjectName, startDate: NSDate())
        projectsTableDataSource.projects.insert(newProject, atIndex: 0)
        newProjectAdded = true
    }
    
    
    @IBAction func cancelAddProjectUnwind(unwindSegue: UIStoryboardSegue) {
        
    }
    
    @IBAction func editProjectUnwind(unwindSegue: UIStoryboardSegue) {
       
    }

//MARK: Status Bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
//MARK: Disable auto rotate
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
}


