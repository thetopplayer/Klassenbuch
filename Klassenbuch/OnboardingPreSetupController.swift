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
    @IBOutlet weak var ImageGIF: UIImageView!
    @IBOutlet weak var NextButton: UIButton!
    @IBOutlet weak var Schliessen: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
   
    //Variables
    var NextButtonClick: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Schliessen.isHidden = true
        cancelButton.isHidden = true
        ImageGIF.loadGif(name: "GIF")
    }

    
    @IBAction func NextGif(_ sender: Any) {
       self.ButtonNext()

    }
   
    
    func ButtonNext(){
    
        if NextButton.tag == 0 {
            
            Schliessen.isHidden = true
            cancelButton.isHidden = true
            ImageGIF.loadGif(name: "GIF2")
            
        }else if NextButton.tag == 1 {
            
            Schliessen.isHidden = true
            cancelButton.isHidden = true
            ImageGIF.loadGif(name: "GIF3")
            
        }
    
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
            }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

