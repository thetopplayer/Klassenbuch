//
//  OnboardingThrid.swift
//  Klassenbuch
//
//  Created by Developing on 11.02.17.
//  Copyright © 2017 Hadorn Developing. All rights reserved.
//

import UIKit

class OnboardingThrid: UIViewController {

     //Outlets
    @IBOutlet weak var PhoneImage3: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //PhoneImage3.loadGif(name: "giphy")  
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
 
}
