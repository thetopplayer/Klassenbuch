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

        
        self.loadingGifs()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
            
            self.PhoneImage3.image = #imageLiteral(resourceName: "LeaveOnboarding")
        }
    }
    
    func loadingGifs(){
        
        PhoneImage3.loadGif(name: "GIF")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 12) {
            
            self.PhoneImage3.image = #imageLiteral(resourceName: "SwipeRight")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 16) {
            
            self.PhoneImage3.loadGif(name: "GIF2")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 28) {
            
            self.PhoneImage3.image = #imageLiteral(resourceName: "SwipeRight")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 32) {
            
            self.PhoneImage3.loadGif(name: "GIF3")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 45) {
            
            self.PhoneImage3.image = #imageLiteral(resourceName: "SwipeRight")
            
        }}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
 
}
