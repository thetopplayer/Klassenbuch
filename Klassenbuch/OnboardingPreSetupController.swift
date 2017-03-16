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
        
        self.loadingGif()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
          self.Schliessen.isHidden = false
        }


       
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
            self.Schliessen.isHidden = true
            self.PhoneImage31.image = #imageLiteral(resourceName: "LeaveOnboarding")
        }
    }


 func loadingGif(){
        
        PhoneImage31.loadGif(name: "GIF3")
        
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
            }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

