//
//  TutorialViewController.swift
//  Klassenbuch
//
//  Created by Developing on 05.02.17.
//  Copyright © 2017 Hadorn Developing. All rights reserved.
//

import UIKit

class TutorialViewController: UIPageViewController, UIPageViewControllerDataSource {

    
    lazy var ViewControllerList:[UIViewController] = {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        
        let vc1 = sb.instantiateViewController(withIdentifier: "First")
        let vc2 = sb.instantiateViewController(withIdentifier: "Second")
        let vc3 = sb.instantiateViewController(withIdentifier: "ThirdOption")
        
        return[vc1, vc2, vc3]
        
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
}


