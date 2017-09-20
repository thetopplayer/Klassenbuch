//
//  Register.swift
//  Klassenbuch
//
//  Created by DeveLloping on 16.01.17.
//  Copyright © 2017 Hadorn Developing. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase

class Register: UIViewController, UITextFieldDelegate {

    //Outlets
    @IBOutlet weak var RegisterEmailTextField: UITextField!
    @IBOutlet weak var RegisterPasswordTextField: UITextField!
    @IBOutlet weak var RegisterPasswordTextField2: AuthTextField!
    @IBOutlet var       InformationView: UIView!
    @IBOutlet weak var VisualEffect: UIVisualEffectView!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var ZüriBild: UIImageView!
    @IBOutlet weak var PasswordLabel: UILabel!
    @IBOutlet weak var RegisterButton: UIButton!
    @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var Form: UIImageView!
    @IBOutlet weak var EyeButton: UIButton!
    @IBOutlet weak var EyeButton2: UIButton!
    @IBOutlet weak var RegisterLabel: UILabel!
    @IBOutlet weak var KSLLabel: UILabel!
//    @IBOutlet weak var EmailLabel2: UILabel!
    @IBOutlet weak var GoToSelectionLabel: UIButton!
    // Variables    
    var effect: UIVisualEffect!
    var iconClick: Bool!
    var iconClick2: Bool!
    var ref:FIRDatabaseReference?
    var RegisterString1 = String()
    var RegisterString2 = "@stud.kslzh.ch"
    var RegisterString = String()
    var Namen = String()
    var Funktion = String()
    var LehrPerson  =   String()
    var FromLogin : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//         RegisterEmailTextField.text = LehrPerson
        AnimationCheck()
        KSLLabelfunc()
        // Parallax Effect
        self.ApplyMotionEffectsforViewDidLoad()
        
        // TextFieldDelegates
        RegisterEmailTextField.delegate = self
        RegisterPasswordTextField.delegate = self
        RegisterPasswordTextField2.delegate = self
//        RegisterEmailTextField.isEnabled = false
        
        //Hide Navigation Bar Controller
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        // Dismiss Keyboard
        self.hideKeyboardWhenTappedAround()
        
        // Eye EyeButton
        
        iconClick = true
        iconClick2 = true
     
        RegisterPasswordTextField.isSecureTextEntry = true
        RegisterPasswordTextField2.isSecureTextEntry = true
        
   
        
        // Cornerradius
        InformationView.layer.cornerRadius = 5
        
        //Database Refrence Property
        ref = FIRDatabase.database().reference()
        
        
    }
    
    
    func AnimationCheck(){
    
        if FromLogin == true {
        
        // Do Animations
            // Visual Effect
            effect = VisualEffect.effect
            VisualEffect.effect = nil
            self.animateIn()
       
            
        } else if FromLogin == false {
        
        // Dont do any Animations1
//            EmailLabel2.text = LehrPerson
            self.VisualEffect.isHidden = true
            self.VisualEffect.isUserInteractionEnabled = false
            self.VisualEffect.effect = nil
        }
    
    }
    
    
    func KSLLabelfunc(){
    
        if Funktion == "Schüler"{
            
            RegisterString2 = "@stud.kslzh.ch"
            
        } else if Funktion == "Lehrer"{
        
//            RegisterString2 = "@kslzh.ch"
            RegisterString2 = "@stud.kslzh.ch"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if Funktion == "Schüler" {
            
            self.loadStudent()
            
        } else if Funktion == "Lehrer" {
            
            self.loadTeacher()
        }
        
    }
    
    func loadStudent(){
        print("Student")
//        EmailLabel2.isHidden = true
        self.RegisterEmailTextField.isEnabled = true
//           self.GoToSelectionLabel.isHidden = true
        RegisterLabel.text = "Schüler Registration"
    }
    
    @IBAction func GoToTeacherSelection(_ sender: UIButton) {
        
        
        
        // Perfrom Segue
        
   //     self.performSegue(withIdentifier: "LehrerAuswahl", sender: nil)

        
    }
    func loadTeacher(){
    print("Teacher")
        RegisterLabel.text = "Lehrer Registration"
        KSLLabel.isHidden = false
        self.RegisterEmailTextField.isEnabled = true
//        self.GoToSelectionLabel.isHidden = false
//        self.RegisterEmailTextField
//        EmailLabel2.text = LehrPerson
 
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
//        if textField == RegisterEmailTextField {
//        
//            if Funktion == "Lehrer"{
//            self.performSegue(withIdentifier: "LehrerAuswahl", sender: nil)
//            }else{
//            }
//            //
//        }
        
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
    
    @IBAction func RemoveInformationView(_ sender: Any) {
       self.animateOut()
    }
   
    @IBAction func backtoLogin(_ sender: Any) {
        performSegue(withIdentifier: "backtoLogin", sender: nil)
    }
    
    // Starting Information Animation
    
    func animateIn() {
        self.view.addSubview(InformationView)
        InformationView.center = self.view.center
        
        InformationView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        InformationView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.VisualEffect.effect = self.effect
            self.InformationView.alpha = 1
            self.InformationView.transform = CGAffineTransform.identity
            self.VisualEffect.isUserInteractionEnabled = true
        }
    }
    
    // Ending Information Animation
    
    func animateOut () {
        UIView.animate(withDuration: 0.3, animations: {
            self.InformationView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.InformationView.alpha = 0
            self.VisualEffect.isUserInteractionEnabled = false
            self.VisualEffect.effect = nil
            
        }) { (success:Bool) in
            self.InformationView.removeFromSuperview()
        }
    }

    //Register User Action
    
    @IBAction func RegisterUser(_ sender: Any) {
    
       //String zusammenführen

        if Funktion == "Schüler"{
            
            RegisterString2 = "@stud.kslzh.ch"
            RegisterString1 = RegisterEmailTextField.text!
            
        } else if Funktion == "Lehrer"{
            
            //            RegisterString2 = "@kslzh.ch"
            RegisterString2 = "@kslzh.ch"
            RegisterString1 = RegisterEmailTextField.text!
        }
        
        RegisterString = "\(RegisterString1.lowercased())\(RegisterString2.lowercased())"
        
        Namen = RegisterString1.replacingOccurrences(of: ".", with: " ", options: .literal, range: nil)
        

        if self.RegisterString1 == "" || self.RegisterPasswordTextField.text == ""
        {
            let alertController = UIAlertController(title: "Oops!", message: "Bitte gib eine korrekte Email an und ein Password mit mindestens 6 Zeichen.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            if self.RegisterPasswordTextField.text == self.RegisterPasswordTextField2.text {
            
                FIRAuth.auth()?.createUser(withEmail: self.RegisterString, password: self.RegisterPasswordTextField.text!) { (user, error) in
                    
                    if error == nil
                        
                    {
                        FIRAnalytics.logEvent(withName: "new registered User", parameters: nil)
                        let alert = UIAlertController(title: "Erfolgreich Registriert", message: "", preferredStyle: .alert)
                        
                        let action = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                      
                           
                          
                            
                         FIRAuth.auth()?.currentUser?.sendEmailVerification()
                        self.CheckWhotoSetup()
                            

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
    
    
    func CheckWhotoSetup(){
    
        if Funktion == "Schüler"{
        
        setupStudentinDatabase()
        self.performSegue(withIdentifier: "SyncClass", sender: self)
        
        } else if Funktion == "Lehrer"{
        
        setupTeacherinDatabase()
        self.performSegue(withIdentifier: "KlassenLehrereinrichten", sender: self)
        }
    
    }
    
    func setupStudentinDatabase(){
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        self.ref?.child("users").child("Schüler").child(uid!).updateChildValues(["email": RegisterString])
        self.ref?.child("users").child("Schüler").child(uid!).updateChildValues(["name": Namen.lowercased()])
        self.ref?.child("users").child("UIDs").child(uid!).updateChildValues(["function": "Student"])
        
        UserDefaults.standard.set(true, forKey: "isStudent")
        UserDefaults.standard.synchronize()
        
       
        
    }
    
    func setupTeacherinDatabase(){
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
//        self.ref?.child("users").child("Lehrer").child(uid!).updateChildValues(["email": RegisterString])
        self.ref?.child("users").child("Lehrer").child(uid!).updateChildValues(["email": RegisterString])
        self.ref?.child("users").child("Lehrer").child(uid!).updateChildValues(["name": Namen.lowercased()])
        self.ref?.child("users").child("UIDs").child(uid!).updateChildValues(["function": "Teacher"])
        self.ref?.child("users").child("Alle Lehrer").updateChildValues([Namen.lowercased(): Namen.lowercased()])
        //self.ref?.child("UID").child(uid!).updateChildValues(["funktion": "Lehrer"])
        UserDefaults.standard.set(true, forKey: "isTeacher")
        UserDefaults.standard.synchronize()
        
 
        
    }
    
    
    @IBAction func backfromTeacherselection2 (_ segue:UIStoryboardSegue) {
    }
    }
