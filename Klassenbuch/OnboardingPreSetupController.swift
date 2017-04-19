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
        self.Schliessen.isHidden = true
        self.loadingGifs()
        
    }



    func loadingGifs(){
        
        PhoneImage31.loadGif(name: "GIF")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 12) {
            
            self.PhoneImage31.image = #imageLiteral(resourceName: "SwipeRight")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 16) {
            
            self.PhoneImage31.loadGif(name: "GIF2")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 28) {
            
            self.PhoneImage31.image = #imageLiteral(resourceName: "SwipeRight")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 32) {
            
            self.PhoneImage31.loadGif(name: "GIF3")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 45) {
            
            self.PhoneImage31.image = #imageLiteral(resourceName: "SwipeRight")
           self.Schliessen.isHidden = false
            
        }}


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
            }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

