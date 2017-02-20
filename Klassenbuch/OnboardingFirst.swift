//
//  OnboardingFirst.swift
//  Klassenbuch
//
//  Created by Developing on 11.02.17.
//  Copyright © 2017 Hadorn Developing. All rights reserved.
//

import UIKit

class OnboardingFirst: UIViewController {

    //Outlets
    @IBOutlet weak var PhoneImage1: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
      //  PhoneImage1.loadGif(name: "giphy")
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
            return true
    }

}
