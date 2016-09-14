//
//  MyTableViewCell.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 19/01/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell, UIScrollViewDelegate {
    
    var project:Project?
    var delegate:ScrollingCellDelegate?
    
    var projectNameLabel = UILabel()
    var facadeView = UIView()
    var scrollView = UIScrollView()
    var cellSeparator = UIView()
    
    @IBOutlet weak var leftDrawer: LeftDrawerView!
    @IBOutlet weak var rightDrawer: RightDrawerView!
    

    var drawerWidth:CGFloat {
        get {
            return leftDrawer.frame.width
        }
    }
    var pullThreshold:CGFloat {
        get {
            return leftDrawer.frame.width
        }
    }
    private var defaultOffset:CGFloat = 0
    private var pulling: Bool = false
    private var deceleratingBackToZero: Bool = false
    private var decelerationDistnaceRatio:CGFloat = 0
    
    override func awakeFromNib() {
        setupLeftDrawer()
        setupRightDrawer()
        setupScrollView()
        setupFacadeView()
        setupProjectNameLabel()
        setupCellSeparator()
        setupTapGestureRecognizer()
        super.awakeFromNib()
    }
    
    private func setupTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyTableViewCell.handleSingleTap(_:)))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    private func setupLeftDrawer() {
        leftDrawer.backgroundColor = Colors.green()
        leftDrawer.fillColor = Colors.almostBlack().withAlpha(0.9)
    }
    
    private func setupRightDrawer() {
        rightDrawer.backgroundColor = Colors.azure()
        rightDrawer.color = Colors.almostBlack().withAlpha(0.9)
    }
    
    private func setupScrollView() {
        scrollView.pagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = UIColor.clearColor()
        contentView.addSubview(scrollView)
    }
    
    private func setupFacadeView() {
        facadeView.backgroundColor = Colors.almostBlack()
        scrollView.addSubview(facadeView)
    }
    
    private func setupProjectNameLabel() {
        projectNameLabel.textColor = Colors.silver()
        projectNameLabel.font = UIFont(name: "Avenir Medium", size: 16)
        projectNameLabel.numberOfLines = 3
        facadeView.addSubview(projectNameLabel)
    }
    
    private func setupCellSeparator() {
        cellSeparator.backgroundColor = Colors.veryLightGray().withAlpha(0.1)
        contentView.addSubview(cellSeparator)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let bounds = contentView.bounds
        let pageWidth = bounds.size.width + pullThreshold
        defaultOffset = pageWidth
        
        //layout scrollView
        scrollView.contentSize = CGSizeMake(3*pageWidth, bounds.size.height)
        scrollView.frame = CGRectMake(0,0, pageWidth, bounds.size.height)
        scrollView.contentOffset = CGPointMake(pageWidth, 0)
        //layout facadeView
        facadeView.frame = scrollView.convertRect(bounds, fromView: contentView)
        //layout projectNameLabel
        projectNameLabel.frame = CGRectMake(15, 2, facadeView.bounds.size.width - 30, facadeView.bounds.size.height - 4)
        //layout cellSeparator
        cellSeparator.frame = CGRectMake(0, bounds.size.height-1, bounds.size.width, 1)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x - defaultOffset
        //did we just start pulling?
        if fabs(offset) > pullThreshold && !pulling {
            pulling = true
            delegate?.scrollingCellDidBeginPulling(self)
        }
        
        if pulling  {
            var pullOffset = CGFloat(0)
            if deceleratingBackToZero {
                pullOffset = offset * decelerationDistnaceRatio
            } else {
                let direction = offset != 0 ? fabs(offset) / offset : 0
                pullOffset = max(0, fabs(offset) - pullThreshold) * direction
            }
            delegate?.scrollingCellDidChangePullOffset(pullOffset)
            scrollView.transform = CGAffineTransformMakeTranslation(pullOffset, 0)
        }
    }
    
    func scrollingEnded() {
        pulling = false
        deceleratingBackToZero = false
        scrollView.contentOffset = CGPointMake(defaultOffset, 0)
        scrollView.transform = CGAffineTransformIdentity
        delegate?.scrollingCellDidEndPulling(self)
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.scrollingEnded()
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.scrollingEnded()
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let offset = scrollView.contentOffset.x - defaultOffset
        if targetContentOffset.memory.x == defaultOffset && fabs(offset)  > 0 {
            deceleratingBackToZero = true
            let direction = fabs(offset) / offset
            let pullOffset = max(0, fabs(offset) - pullThreshold) * direction
            decelerationDistnaceRatio = fabs(pullOffset / offset)
        }
    }
    
    //MARK: Tap Gesture Recognizer
    func handleSingleTap(tapGestureRecognizer:UITapGestureRecognizer) {
        let shakeAnimation = CAKeyframeAnimation(keyPath: "position.x")
        
        shakeAnimation.values = [0, 30, 0, -30, 0]
        shakeAnimation.keyTimes = [0.0, 1.0/4.0, 2.0/4.0 , 3.0/4.0, 1.0]
        shakeAnimation.duration = 0.6
        shakeAnimation.additive = true
        shakeAnimation.removedOnCompletion = true
        
        facadeView.layer.addAnimation(shakeAnimation, forKey: "shake")
    }
}
