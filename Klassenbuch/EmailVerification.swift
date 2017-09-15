//
//  EmailVerification.swift
//  Klassenbuch
//
//  Created by Developing on 01.09.17.
//  Copyright © 2017 Hadorn Developing. All rights reserved.
//

import UIKit
import Firebase

class EmailVerification: UIViewController {
   
  

    let user = FIRAuth.auth()?.currentUser
    var verificationTimer1 : Timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        sendVerifiactionEmail()
//        LabelUpdate()
           // Timer's  Global declaration
        
        self.verificationTimer1 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(EmailVerification.checkIfTheEmailIsVerified) , userInfo: nil, repeats: true)
//        _ = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(EmailVerification.LabelUpdate), userInfo: nil, repeats: true)
    }



    
    
    @objc func checkIfTheEmailIsVerified(){
        
        FIRAuth.auth()?.currentUser?.reload(completion: { (err) in
            if err == nil{
                
                if FIRAuth.auth()!.currentUser!.isEmailVerified{
                             self.performSegue(withIdentifier: "emailverified", sender: self)

                    self.verificationTimer1.invalidate()     //Kill the timer
                   print("verified XXXXXXXXX")
                    
                } else {
                    
                    print("It aint verified yet")
                // oNly for development
                                       self.performSegue(withIdentifier: "emailverified", sender: self)
                    self.verificationTimer1.invalidate()
                }
            } else {
                
                print(err?.localizedDescription)
                
            }
        })
        
    }

    @IBAction func LogOut(_ sender: Any) {
        
        
        
    }

}
