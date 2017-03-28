//
//  OnboardingSetupController.swift
//  Klassenbuch
//
//  Created by Developing on 06.02.17.
//  Copyright © 2017 Hadorn Developing. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class OnboardingSetupController: UIViewController, UITextFieldDelegate {

    
    //Outlets
    
    @IBOutlet weak var KlassenNamenTextField: AuthTextField!
    
    // Variables
    var ref: FIRDatabaseReference?
    var databaseHandle: FIRDatabaseHandle?
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Hide Keyboard
        self.hideKeyboardWhenTappedAround()

        // TextField Delegates
        KlassenNamenTextField.delegate = self
        
        ref = FIRDatabase.database().reference()
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        self.ref?.child("users").child(uid!).child("KlassenInfos").setValue(["Name": "AFFE"])
       
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // Next Button Klicked Textfield resigns First Responder
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == KlassenNamenTextField{
            KlassenNamenTextField.resignFirstResponder()
        } else {
    }
        return true
    }
    
    
    
    
    @IBAction func GotoAppforthefirstTime(_ sender: Any) {
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        self.ref?.child("users").child(uid!).child("KlassenInfos").setValue(["Name": self.KlassenNamenTextField.text!])
        self.Checkstatus()
    }
   
    
    // Keeped Users logged in
    
    func Checkstatus(){
       
        if self.KlassenNamenTextField.text == "" {
        
        // Alertcontroller KlassenNamenTextField is empty
        
            let alertController = UIAlertController(title: "Oops!", message: "Bitte gib einen Klassen Namen ein.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)

            
        }else {

        FIRAuth.auth()?.addStateDidChangeListener { auth, authuser in
           
            
            if authuser != nil {
                // User is signed in. Show home screen
                
                UserDefaults.standard.set(true, forKey: "launchedBefore") 
                self.performSegue(withIdentifier: "SetupUpMadeHomePage", sender: self)
                
                let user = FIRAuth.auth()?.currentUser
                let uid = user?.uid
                self.ref?.child("users").child(uid!).child("KlassenInfos").setValue(["klassenname": self.KlassenNamenTextField.text!])

            } else {
               
                // Alert Controller if there was a Failure
               
                print("Auth Check Failure.")
                
                let AuthController = UIAlertController(title: "Ooops!", message: "Es gab einen Fehler mit deiner Identifikation.", preferredStyle: .alert)
                
                AuthController.addAction(UIAlertAction(title: "Zurück zum Login", style: .default, handler: { (action: UIAlertAction!) in
                   
                    print("Send to Login")
                   
                    self.performSegue(withIdentifier: "AuthCheckFailed", sender: self)
                    
                                   }))
                self.present(AuthController, animated: true, completion: nil)
                
                }
            }
        }
   
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
  
}
