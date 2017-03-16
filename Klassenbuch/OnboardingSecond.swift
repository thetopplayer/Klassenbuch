//
//  OnboardingSecond.swift
//  Klassenbuch
//
//  Created by Developing on 11.02.17.
//  Copyright © 2017 Hadorn Developing. All rights reserved.
//

import UIKit

class OnboardingSecond: UIViewController {

    //Outlets
    @IBOutlet weak var PhoneImage2: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadingGif()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 12) {
            
            self.PhoneImage2.image = #imageLiteral(resourceName: "SwipeRight")
        }
    }
    
    func loadingGif(){
        
        PhoneImage2.loadGif(name: "GIF2")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
          }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}
