
    //
    //  Login.swift
    //  Klassenbuch
    //
    //  Created by Developing on 16.01.17.
    //  Copyright © 2017 Hadorn Developing. All rights reserved.
    
    
    import UIKit
    import Firebase
    
    
    class LehrerLogin: UIViewController, UITextFieldDelegate {
        
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
        @IBOutlet weak var Stack1: UIStackView!
        @IBOutlet weak var Stack2: UIStackView!
        @IBOutlet weak var LehrerLoginLabel: UILabel!
        
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
            
            self.LoginEmailTextField.alpha = 0
            self.LoginPasswordTextField.alpha = 0
            //self.BackgroundImage.alpha = 1
            self.ZüriBild.alpha = 0
            self.EmailLabel.alpha = 0
            self.PasswordLabel.alpha = 0
            self.LoginButton.alpha = 0
            self.EyeButton.alpha = 0
            self.Form.alpha = 0
            self.Stack1.alpha = 0
            self.Stack2.alpha = 0
            self.LehrerLoginLabel.alpha = 0
        }
        
        override func viewDidAppear(_ animated: Bool) {
            
            UIView.animate(withDuration: 0.6 , animations: {
                self.LoginEmailTextField.alpha = 1
                self.LoginPasswordTextField.alpha = 1
                self.ZüriBild.alpha = 1
                self.EmailLabel.alpha = 1
                self.PasswordLabel.alpha = 1
                self.LoginButton.alpha = 1
                self.EyeButton.alpha = 1
                self.Form.alpha = 0.95
                self.Stack1.alpha = 1
                self.Stack2.alpha = 1
                self.LehrerLoginLabel.alpha = 1
            })
        }
        
        
        // Next Button Klicked Textfield denn new First Responder
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
            
//            FIRAuth.auth()?.addStateDidChangeListener { auth, authuser in
//                
//                if authuser != nil {
//                    self.performSegue(withIdentifier: "HomePageSegue", sender: self)
//                    
//                } else {
//                    // No User is signed in. Show user the login screen
//                }}
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
                        self.performSegue(withIdentifier: "LehrerHomePageSegue", sender: self)
                        self.LoginEmailTextField.text = ""
                        self.LoginPasswordTextField.text = ""
                        FIRAnalytics.logEvent(withName: "new Login", parameters: nil)
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
            // applyMotionEffect(toView: BackgroundImage, magnitude: 0)
            applyMotionEffect(toView: Form, magnitude: -10)
            applyMotionEffect(toView: ZüriBild, magnitude: -10)
            applyMotionEffect(toView: LoginEmailTextField, magnitude: -10)
            applyMotionEffect(toView: LoginPasswordTextField, magnitude: -10)
            applyMotionEffect(toView: EmailLabel, magnitude: -10)
            applyMotionEffect(toView: PasswordLabel, magnitude: -10)
            applyMotionEffect(toView: LoginButton, magnitude: -10)
            applyMotionEffect(toView: EyeButton, magnitude: -10)
        }
        
        @IBAction func backLehrerRegistration (_ segue:UIStoryboardSegue) {
        }
        
}
