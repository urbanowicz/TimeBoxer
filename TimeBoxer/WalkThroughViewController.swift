//
//  WalkthroughViewController.swift
//  Walkthrough
//
//  Created by Tomasz Urbanowicz on 13/10/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class WalkthroughViewController: UIPageViewController,UIPageViewControllerDataSource, LastSlideDelegate {
    var slides = [UIViewController]()
    var numberOfSlides = 8
    var currentSlide = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 1...numberOfSlides - 1 {
            let slideVC = WalkthroughSlideViewController(slideName: "slide\(i)")
            slides.append(slideVC)
        }
        let lastSlideVC = LastSlideViewController(slideName: "slide\(numberOfSlides)")
        lastSlideVC.delegate = self
        slides.append(lastSlideVC)
        
        dataSource = self
        setViewControllers([slides.first!], direction: .Forward, animated: true, completion: nil)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if viewController == slides.last {
            return nil
        } else {
            let currentIndex = slides.indexOf(viewController)!
            currentSlide = currentIndex + 1
            return slides[currentSlide]
            
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if viewController == slides.first {
            return nil
        } else {
            let currentIndex = slides.indexOf(viewController)!
            currentSlide = currentIndex - 1
            return slides[currentSlide]
        }
    }
    
    //    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
    //        return numberOfSlides
    //    }
    //
    //    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
    //        return currentSlide
    //    }
    
    func okButtonPressed() {
        let containerVC = parentViewController as! ImprovedContainerViewController
        containerVC.popViewController(FadeInAnimator())
    }
}

