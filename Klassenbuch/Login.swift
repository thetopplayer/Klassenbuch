//
//  Login.swift
//  Klassenbuch
//
//  Created by Developing on 16.01.17.
//  Copyright © 2017 Hadorn Developing. All rights reserved.
// Original ORiginal

import UIKit
import Firebase


class Login: UIViewController, UITextFieldDelegate {

    // Outlets
    
    @IBOutlet weak var LoginEmailTextField: UITextField!
    @IBOutlet weak var LoginPasswordTextField: UITextField!
    @IBOutlet weak var BackgroundImage: UIImageView!
    @IBOutlet weak var ZüriBild: UIImageView!
    @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var PasswordLabel: UILabel!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var EyeButton: UIButton!
    @IBOutlet weak var Form: UIImageView!
    
    // Variables
    var iconClick: Bool!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Keep User Logged In
        self.KeepUserSigndIn()

        
        //Motion Setup
        self.ApplyMotionEffectsforViewDidLoad()
        
        // TextFieldDelegates
        LoginEmailTextField.delegate = self
        LoginPasswordTextField.delegate = self
        
        // Hide Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        //Hide Keyboard
        self.hideKeyboardWhenTappedAround()
        
        // Eye EyeButton
        iconClick = true
        LoginPasswordTextField.isSecureTextEntry = true
       
    }

    
    // Next Button Klicked Textfield new First Responder
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == LoginEmailTextField{
        LoginPasswordTextField.becomeFirstResponder()
        } else {

        LoginPasswordTextField.resignFirstResponder()
        LoginPasswordTextField.isSecureTextEntry = true
        }
        return true
    }
    
    //Showing and Hiding the Eye Button
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == LoginPasswordTextField {
        
            EyeButton.isHidden = false
            
        }else {
        
             EyeButton.isHidden = true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == LoginPasswordTextField{
        EyeButton.setImage(UIImage(named: "Eye"), for: UIControlState.normal)
        LoginPasswordTextField.isSecureTextEntry = true
        }
    }
    
    
    // PasswordEyeButton Tapped Once
    
    @IBAction func EyeTapped(_ sender: Any) {

        if EyeButton.tag == 0
        {
            (sender as AnyObject).setImage(UIImage(named: "Eye Selected"), for: UIControlState.normal)
                        EyeButton.tag=1
        }
        else
        {
            (sender as AnyObject).setImage(UIImage(named: "Eye"), for: UIControlState.normal)
            EyeButton.tag=0
        }
        
        if(iconClick == true) {
            
            LoginPasswordTextField.isSecureTextEntry = false
            
            iconClick = false
        } else {
            LoginPasswordTextField.isSecureTextEntry = true
            iconClick = true
        }
    }
    
    
    // Keeped Users logged in
    
    func KeepUserSigndIn(){
        
        FIRAuth.auth()?.addStateDidChangeListener { auth, authuser in
          
            if authuser != nil {
                    self.performSegue(withIdentifier: "HomePageSegue", sender: self)
                
                } else {
                // No User is signed in. Show user the login screen
            }
        }
    }
    
    

    
    // Login Function
    
    @IBAction func LoginUser(_ sender: Any) {
    
        if self.LoginEmailTextField.text == "" || self.LoginPasswordTextField.text == ""
        {
            let alertController = UIAlertController(title: "Oops!", message: "Bitte gib eine Email Adresse und ein Password ein.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            FIRAuth.auth()?.signIn(withEmail: self.LoginEmailTextField.text!, password: self.LoginPasswordTextField.text!) { (user, error) in
                
                if error == nil
                {
                    self.performSegue(withIdentifier: "HomePageSegue", sender: self)
                    self.LoginEmailTextField.text = ""
                    self.LoginPasswordTextField.text = ""
                }
                else
                {
                    let alertController = UIAlertController(title: "Oops!", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
    }  } } }
    
  

    
    // Register Button pressed, Text is empty
    
    @IBAction func RegisteredPressed(_ sender: UIButton) {
    
        self.LoginEmailTextField.text = ""
        self.LoginPasswordTextField.text = ""
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Cancel Registration
    
        @IBAction func cancelRegistration (_ segue:UIStoryboardSegue) {
    }
    
    // Cancel Restore Password
    
    @IBAction func cancelRestorePassword (_ segue:UIStoryboardSegue) {
    }

    // Motion Effect
    
    func applyMotionEffect (toView view:UIView, magnitude:Float) {
        let xMotion = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = -magnitude
        xMotion.maximumRelativeValue = magnitude
        
        let yMotion = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = -magnitude
        yMotion.maximumRelativeValue = magnitude
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [xMotion, yMotion]
        
        view.addMotionEffect(group)
    }

    func ApplyMotionEffectsforViewDidLoad() {
        applyMotionEffect(toView: BackgroundImage, magnitude: 5)
        applyMotionEffect(toView: Form, magnitude: -10)
        applyMotionEffect(toView: ZüriBild, magnitude: -10)
        applyMotionEffect(toView: LoginEmailTextField, magnitude: -10)
        applyMotionEffect(toView: LoginPasswordTextField, magnitude: -10)
        applyMotionEffect(toView: EmailLabel, magnitude: -10)
        applyMotionEffect(toView: PasswordLabel, magnitude: -10)
        applyMotionEffect(toView: LoginButton, magnitude: -10)
        applyMotionEffect(toView: EyeButton, magnitude: -10)
    }
   
    
    
}
