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

        
        self.loadingGif()
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 12) {
            
            self.PhoneImage1.image = #imageLiteral(resourceName: "SwipeRight")
        }
    }
    
    func loadingGif(){
    
     PhoneImage1.loadGif(name: "GIF")
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
            return true
    }

}
