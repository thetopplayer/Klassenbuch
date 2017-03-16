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

        self.loadingGif()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
            
            self.PhoneImage3.image = #imageLiteral(resourceName: "LeaveOnboarding")
        }
    }
    
    func loadingGif(){
        
        PhoneImage3.loadGif(name: "GIF3")
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
 
}
