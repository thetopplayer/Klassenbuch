
    //
    //  Register.swift
    //  Klassenbuch
    //
    //  Created by Developing on 16.01.17.
    //  Copyright © 2017 Hadorn Developing. All rights reserved.
    //
    
    import UIKit
    import FirebaseAuth
    import FirebaseDatabase
    import Firebase
    
    class LehrerRegister: UIViewController, UITextFieldDelegate {
        
        //Outlets
        @IBOutlet weak var RegisterEmailTextField: UITextField!
        @IBOutlet weak var RegisterPasswordTextField: UITextField!
        @IBOutlet weak var RegisterPasswordTextField2: AuthTextField!
        
        @IBOutlet weak var VisualEffect: UIVisualEffectView!
        @IBOutlet weak var background: UIImageView!
        @IBOutlet weak var ZüriBild: UIImageView!
        @IBOutlet weak var PasswordLabel: UILabel!
        @IBOutlet weak var RegisterButton: UIButton!
        @IBOutlet weak var EmailLabel: UILabel!
        @IBOutlet weak var Form: UIImageView!
        @IBOutlet weak var EyeButton: UIButton!
        @IBOutlet weak var EyeButton2: UIButton!
        @IBOutlet weak var Lehrerloginlabel: UILabel!
        
        
        // Variables
        var effect: UIVisualEffect!
        var iconClick: Bool!
        var iconClick2: Bool!
        var ref:FIRDatabaseReference?
        var RegisterString1 = String()
        var RegisterString2 = "@kslzh.ch"
        var RegisterString = String()
        var Namen = String()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Parallax Effect
            self.ApplyMotionEffectsforViewDidLoad()
            
            // TextFieldDelegates
            RegisterEmailTextField.delegate = self
            RegisterPasswordTextField.delegate = self
            RegisterPasswordTextField2.delegate = self
            
            //Hide Navigation Bar Controller
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            
            // Dismiss Keyboard
            self.hideKeyboardWhenTappedAround()
            
            // Eye EyeButton
            
            iconClick = true
            iconClick2 = true
            
            RegisterPasswordTextField.isSecureTextEntry = true
            RegisterPasswordTextField2.isSecureTextEntry = true
            
            // Visual Effect
            effect = VisualEffect.effect
            VisualEffect.effect = nil
           
            
       
            
            //Database Refrence Property
            ref = FIRDatabase.database().reference()
            
            
        }
        
        // Next Button Klicked Textfield new First Responder
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if textField == RegisterEmailTextField{
                RegisterPasswordTextField.becomeFirstResponder()
            } else {
                
                RegisterPasswordTextField.isSecureTextEntry = true
                RegisterPasswordTextField2.becomeFirstResponder()
                
                if textField == RegisterPasswordTextField2{
                    RegisterPasswordTextField2.resignFirstResponder()
                    RegisterPasswordTextField2.isSecureTextEntry = true
                }else{
                }}
            return true
        }
        
        //Showing and Hiding the Eye Button
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
//            if textField == RegisterEmailTextField {
//                
//                self.performSegue(withIdentifier: "LehrerAuswahl", sender: nil)
//            }
            
            if textField == RegisterPasswordTextField {
                EyeButton.isHidden = false
            }else {
                EyeButton.isHidden = true
            }
            if textField == RegisterPasswordTextField2 {
                EyeButton2.isHidden = false
            }else{
                EyeButton2.isHidden = true
            }
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            if textField == RegisterPasswordTextField{
                EyeButton.setImage(UIImage(named: "Eye"), for: UIControlState.normal)
                RegisterPasswordTextField.isSecureTextEntry = true
            }
            if textField == RegisterPasswordTextField2{
                EyeButton2.setImage(UIImage(named: "Eye"), for: UIControlState.normal)
                RegisterPasswordTextField2.isSecureTextEntry = true
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
                
                RegisterPasswordTextField.isSecureTextEntry = false
                RegisterPasswordTextField2.isSecureTextEntry = false
                iconClick = false
            } else {
                RegisterPasswordTextField.isSecureTextEntry = true
                RegisterPasswordTextField2.isSecureTextEntry = true
                iconClick = true
            }
        }
        
        
        @IBAction func EyeTapped2(_ sender: Any) {
            if EyeButton2.tag == 0
            {
                (sender as AnyObject).setImage(UIImage(named: "Eye Selected"), for: UIControlState.normal)
                EyeButton2.tag=1
            }
            else
            {
                (sender as AnyObject).setImage(UIImage(named: "Eye"), for: UIControlState.normal)
                EyeButton2.tag=0
            }
            
            if(iconClick2 == true) {
                
                RegisterPasswordTextField.isSecureTextEntry = false
                RegisterPasswordTextField2.isSecureTextEntry = false
                
                iconClick2 = false
            } else {
                RegisterPasswordTextField.isSecureTextEntry = true
                RegisterPasswordTextField2.isSecureTextEntry = true
                iconClick2 = true
            }
        }
        
        //Dismiss ViewAction

    
        
        // Starting Information Animation
        
 
        //Register User Action
        
        @IBAction func RegisterUser(_ sender: Any) {
            
            //String zusammenführen
            
            RegisterString1 = RegisterEmailTextField.text!
            
            RegisterString = "\(RegisterString1.lowercased())\(RegisterString2.lowercased())"
            
            Namen = RegisterString1.replacingOccurrences(of: ".", with: " ", options: .literal, range: nil)
            
            
            if self.RegisterString == "" || self.RegisterPasswordTextField.text == ""
            {
                let alertController = UIAlertController(title: "Oops!", message: "Bitte gib eine korrekte Email an und ein Password mit mindestens 6 Zeichen.", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
            else
            {
                if self.RegisterPasswordTextField.text == self.RegisterPasswordTextField2.text {
                    
                    FIRAuth.auth()?.createUser(withEmail: RegisterString, password: self.RegisterPasswordTextField.text!) { (user, error) in
                        
                        if error == nil
                            
                        {
                            FIRAnalytics.logEvent(withName: "new registered User", parameters: nil)
                            let alert = UIAlertController(title: "Erfolgreich Registriert", message: "", preferredStyle: .alert)
                            
                            let action = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                                
                                self.setupUserinDatabase()
                                
                                self.performSegue(withIdentifier: "KlassenLehrereinrichten", sender: self)
                                
                                
                            }
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: nil)
                        }
                        else
                        {
                            let alertController = UIAlertController(title: "Oops!", message: error?.localizedDescription, preferredStyle: .alert)
                            
                            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alertController.addAction(defaultAction)
                            
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                    
                } else {
                    
                    let alertController = UIAlertController(title: "Oops!", message: "Die Passwörter die du eingegeben hast stimmen nicht überrein.", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }}
        
        
        // Apply Parallax Effect
        
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
            //applyMotionEffect(toView: background, magnitude: 5)
            applyMotionEffect(toView: Form, magnitude: -10)
            applyMotionEffect(toView: ZüriBild, magnitude: -10)
            applyMotionEffect(toView: RegisterPasswordTextField, magnitude: -10)
            applyMotionEffect(toView: RegisterEmailTextField, magnitude: -10)
            applyMotionEffect(toView: EmailLabel, magnitude: -10)
            applyMotionEffect(toView: PasswordLabel, magnitude: -10)
            applyMotionEffect(toView: RegisterButton, magnitude: -10)
            applyMotionEffect(toView: EyeButton, magnitude: -10)
        }
        
        
        
        
        @IBAction func cancelClassSetup (_ segue:UIStoryboardSegue) {
        }
        
        
        
        // Write Users to Database
        
        func setupUserinDatabase(){
            let user = FIRAuth.auth()?.currentUser
            let uid = user?.uid
            self.ref?.child("users").child("Lehrer").child(uid!).updateChildValues(["email": RegisterString])
            self.ref?.child("users").child("Lehrer").child(uid!).updateChildValues(["name": Namen.lowercased()])
          //self.ref?.child("UID").child(uid!).updateChildValues(["funktion": "Lehrer"])
            UserDefaults.standard.set(true, forKey: "isTeacher")
            UserDefaults.standard.synchronize()
            
        }
}