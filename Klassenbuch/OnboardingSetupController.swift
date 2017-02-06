//
//  OnboardingSetupController.swift
//  Klassenbuch
//
//  Created by Developing on 06.02.17.
//  Copyright © 2017 Hadorn Developing. All rights reserved.
//

import UIKit

class OnboardingSetupController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func GotoAppforthefirstTime(_ sender: Any) {
  
    // setup the NSUserdefaults
        
    // perform Segue to App Homescreen
    
        self.performSegue(withIdentifier: "SetupUpMadeHomePage", sender: self)
    
    }
   

}
