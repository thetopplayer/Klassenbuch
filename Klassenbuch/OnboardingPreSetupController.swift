//
//  OnboardingPreSetupController.swift
//  Klassenbuch
//
//  Created by Developing on 09.02.17.
//  Copyright © 2017 Hadorn Developing. All rights reserved.
//

import UIKit

class OnboardingPreSetupController: UIViewController {

    //Outlets
    @IBOutlet weak var PhoneImage31: UIImageView!
    
    @IBOutlet weak var Schliessen: UIImageView!
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
          self.Schliessen.isHidden = false
        }


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

