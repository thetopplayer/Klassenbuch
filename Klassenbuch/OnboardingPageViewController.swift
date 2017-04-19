//
//  OnboardingPageViewController.swift
//  Klassenbuch
//
//  Created by Developing on 06.02.17.
//  Copyright © 2017 Hadorn Developing. All rights reserved.
//

import UIKit

class OnboardingPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    
    lazy var ViewControllerList:[UIViewController] = {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        
        let vc1 = sb.instantiateViewController(withIdentifier: "Third")
        let vc2 = sb.instantiateViewController(withIdentifier: "Fourth")
     
        return[vc1, vc2]
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        if let firstViewController = ViewControllerList.first{
            
            
            self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
            
        }
        
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        
        guard let vcIndex = ViewControllerList.index(of: viewController) else {return nil}
        
        let previousIndex = vcIndex - 1
        
        guard previousIndex >= 0 else {return nil}
        
        guard ViewControllerList.count > previousIndex else {return nil}
        
        return ViewControllerList[previousIndex]
        
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = ViewControllerList.index(of: viewController) else {return nil}
        
        let nextIndex = vcIndex + 1
        
        guard ViewControllerList.count != nextIndex else {return nil}
        
        guard ViewControllerList.count > nextIndex else {return nil}
        
        return ViewControllerList[nextIndex]
        
    }
   
    override var prefersStatusBarHidden: Bool {
        return true
    }
}


