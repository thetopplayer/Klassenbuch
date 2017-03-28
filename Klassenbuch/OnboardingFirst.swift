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

        
        self.loadingGifs()
    
    }
    
    func loadingGifs(){
    
        PhoneImage1.loadGif(name: "GIF")
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 12) {
            
            self.PhoneImage1.image = #imageLiteral(resourceName: "SwipeRight")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 24) {
            
            self.PhoneImage1.loadGif(name: "GIF2")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 48) {
            
            self.PhoneImage1.image = #imageLiteral(resourceName: "SwipeRight")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
            
            self.PhoneImage1.loadGif(name: "GIF3")
        }
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
            return true
    }

}
