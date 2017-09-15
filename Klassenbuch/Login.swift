//
//  Login.swift
//  Klassenbuch
//
//  Created by Developing on 16.01.17.
//  Copyright © 2017 Hadorn Developing. All rights reserved.


import UIKit
import FirebaseDatabase
import FirebaseAuth


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
    @IBOutlet weak var Stack1: UIStackView!
    @IBOutlet weak var Stack2: UIStackView!
    @IBOutlet weak var Stack3: UIStackView!
    @IBOutlet var TeacherStudentView: UIView!
 
    @IBOutlet weak var SegmentedController: UISegmentedControl!
    
    // Variables
    var iconClick = Bool()
    var funktion  = String()
    var ref: FIRDatabaseReference?

    var LoginString1 = String()
    var LoginString2 = String()
    var LoginString = String()
    var ToggleState = String()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ToggleState = "1"
        LoginString2 = "@kslzh.ch"
         ref = FIRDatabase.database().reference()
        
          //  LoginEmailTextField.becomeFirstResponder()
        // Cornerradius
        TeacherStudentView.layer.cornerRadius = 5
        loggin()

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
        self.Stack3.alpha = 0
    }

    override func viewDidAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 0.4 , animations: {
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
        self.Stack3.alpha = 1
         })
    }
    

    
    // Next Button Klicked Textfield denn new First Responder
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == LoginEmailTextField{
        LoginPasswordTextField.becomeFirstResponder()
        } else if textField == LoginPasswordTextField{

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
    func loggin(){
        
        
        FIRAuth.auth()?.addStateDidChangeListener { auth, authuser in
            
            if authuser != nil {
                if UserDefaults.standard.bool(forKey: "isStudent") == true {
                    
                    
                    if UserDefaults.standard.bool(forKey: "StudenthasClass") == true {
                        
                        self.performSegue(withIdentifier: "HomePageSegue", sender: self)
                        print("Student has Class")
                    }
                        
                    else if UserDefaults.standard.bool(forKey: "StudenthasClass") == false {
                        
                        
                        // Perfrom Segue go to ClassSelection
                        
                        self.performSegue(withIdentifier: "GoToSelectClass", sender: self)
                        print("Student has Class")
                    }
                    
                    
                } else if UserDefaults.standard.bool(forKey: "isTeacher") == true {
                    
                    if UserDefaults.standard.bool(forKey: "TeacherhasClass") == true {
                        
                        self.performSegue(withIdentifier: "LehrerHP", sender: self)
                        print("Teacher has Class")
                    }
                        
                    else if UserDefaults.standard.bool(forKey: "TeacherhasClass") == false {
                        
                        
                        // Perfrom Segue go to ClassSelection
                        
                        self.performSegue(withIdentifier: "TeacherNeedsClass", sender: self)
                        print("Teacher has Class")
                    }
                }
                
            }else {
                
                print("notloggedin")
            }}
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
    
    

    
    // Login Function
    @IBAction func LoginUser(_ sender: Any) {
      
        if ToggleState == "1"{
        
            ToggleState = "2"
            animateIn()
        
        }else if ToggleState == "2"{
        
            ToggleState = "1"
        
        observeSegment()
        
        
        LoginString1 = LoginEmailTextField.text!
        
        LoginString = "\(LoginString1.lowercased())\(LoginString2.lowercased())"
        
    
        if self.LoginString == "" || self.LoginPasswordTextField.text == ""
        {
            let alertController = UIAlertController(title: "Oops!", message: "Bitte gib eine Email Adresse und ein Password ein.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            FIRAuth.auth()?.signIn(withEmail: LoginString, password: self.LoginPasswordTextField.text!) { (user, error) in
                
                if error == nil
                {
                    
                    // Hier Check wegen UID eb UID Schüler für value hat oder lehrer und dann jeweils jeder segue
                   
                    self.checkIfStudentOrTeacherLogin()

                }
                else
                {
   
                    
                    let alertController = UIAlertController(title: "Oops!", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
    
                }
            }
            }
        }
    }


    
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
    
    
    
   

    

    
    
    func checkIfStudentOrTeacherLogin() {
    
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        FIRAuth.auth()?.addStateDidChangeListener { auth, authuser in
            
            if authuser != nil {
        
        //ref = FIRDatabase.database().reference()
        self.ref?.child("users").child("UIDs").child(uid!).child("function").observe(.value, with: { (snapshot) in
            
            
            if snapshot.value as? String == "Student" {
              // Schüler Login
                
                UserDefaults.standard.set(true, forKey: "isStudent")
                UserDefaults.standard.synchronize()
                self.performSegue(withIdentifier: "HomePageSegue", sender: self)
                self.LoginEmailTextField.text = ""
                self.LoginPasswordTextField.text = ""
       
      
            } else if snapshot.value as? String == "Teacher" {
                // Teacher Login
                
                UserDefaults.standard.set(true, forKey: "isTeacher")
                UserDefaults.standard.synchronize()
                self.performSegue(withIdentifier: "LehrerHP", sender: self)
                self.LoginEmailTextField.text = ""
                self.LoginPasswordTextField.text = ""
 
            }
        }
                )}
    }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "LehrerRegister"{
           
            let DestViewController = segue.destination as! Register
            DestViewController.FromLogin = true
            DestViewController.Funktion = "Lehrer"
        }
       
        else if segue.identifier == "SchülerRegister"{
            
            let DestViewController = segue.destination as! Register
            DestViewController.FromLogin = true
            DestViewController.Funktion = "Schüler"
        }
    }
    
    @IBAction func backLehrerLogin (_ segue:UIStoryboardSegue) {
    }
    @IBAction func backLehrerRegister (_ segue:UIStoryboardSegue) {
    }
    
    
    
    func observeSegment(){
    
    
    
        if SegmentedController.selectedSegmentIndex == 0{
        LoginString2 = "@stud.kslzh.ch"
        
        } else if SegmentedController.selectedSegmentIndex == 1 {
        
        LoginString2 = "@kslzh.ch"
        }
    }
    
    // Starting TeacherStudent Animation
    
    func animateIn() {
        
        UIView.animate(withDuration: 0.2 , animations: {
        self.LoginEmailTextField.alpha = 0
        self.LoginPasswordTextField.alpha = 0
        self.ZüriBild.alpha = 0
        self.EmailLabel.alpha = 0
        self.PasswordLabel.alpha = 0
        self.LoginButton.alpha = 0
        self.EyeButton.alpha = 0
        self.Form.alpha = 0
        self.Stack1.alpha = 0
        self.Stack2.alpha = 0
        self.Stack3.alpha = 0
        
          })
        
        
        self.view.addSubview(TeacherStudentView)
        TeacherStudentView.center = self.view.center
        
        TeacherStudentView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        TeacherStudentView.alpha = 0
        
        UIView.animate(withDuration: 0.2) {
          
            self.TeacherStudentView.alpha = 1
            self.TeacherStudentView.transform = CGAffineTransform.identity
         
        }
    }
    
    // Ending Information Animation
    
    func animateOut () {
       
        UIView.animate(withDuration: 0.2 , animations: {
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
            self.Stack3.alpha = 1
        })
        
        ToggleState = "2"
        
        UIView.animate(withDuration: 0.2, animations: {
            self.TeacherStudentView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.TeacherStudentView.alpha = 0
          
          
            
        }) { (success:Bool) in
            self.TeacherStudentView.removeFromSuperview()
        }
    }

    @IBAction func OKAction(_ sender: Any) {
         animateOut()
    }

}
