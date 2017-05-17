//
//  AppInfo.swift
//  Klassenbuch
//
//  Created by Developing on 03.02.17.
//  Copyright © 2017 Hadorn Developing. All rights reserved.
//

import UIKit


class AppInfo: UIViewController {

    //Outlets
    @IBOutlet weak var First: UIView!
    @IBOutlet weak var Second: UIView!
    @IBOutlet weak var Third: UIView!
    @IBOutlet weak var background2: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        self.ApplyMotionEffectsforViewDidLoad()
        
        
        First.layer.cornerRadius = 5
        Second.layer.cornerRadius = 5
        Third.layer.cornerRadius = 5
        
        // Left Swipe
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .left
        
        view.addGestureRecognizer(edgePan)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }

    // MARK: - Table view data source

   
       //Fund for Left Swipe
    
    func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        
        if recognizer.state == .recognized {
            self.performSegue(withIdentifier: "unwindtoSettings", sender: self)
            
        }
    }
    // Motion Effect
    
    func applyMotionEffect (toView view:UIView, magnitude:Float) {
        let xMotion = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = -magnitude
        xMotion.maximumRelativeValue = magnitude
        
        let yMotion = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = -magnitude
        yMotion.maximumRelativeValue = magnitude
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [xMotion, yMotion]
        
        view.addMotionEffect(group)
    }
    
    func ApplyMotionEffectsforViewDidLoad() {
        applyMotionEffect(toView: background2, magnitude: 5)
        applyMotionEffect(toView: First, magnitude: -10)
        applyMotionEffect(toView: Second, magnitude: -10)
        applyMotionEffect(toView: Third, magnitude: -10)
      
    }

}
