//
//  Register.swift
//  Klassenbuch
//
//  Created by Developing on 16.01.17.
//  Copyright © 2017 Hadorn Developing. All rights reserved.
//

import UIKit
import Firebase

class Register: UIViewController {

    //Outlets
    
    
    @IBOutlet weak var RegisterEmailTextField: UITextField!
    @IBOutlet weak var RegisterPasswordTextField: UITextField!
    @IBOutlet var       InformationView: UIView!
    @IBOutlet weak var VisualEffect: UIVisualEffectView!
    @IBOutlet weak var background: UIVisualEffectView!
    @IBOutlet weak var ZüriBild: UIImageView!
    @IBOutlet weak var PasswordLabel: UILabel!
    @IBOutlet weak var RegisterButton: UIButton!
    @IBOutlet weak var EmailLabel: UIButton!
    @IBOutlet weak var Form: UIImageView!
    

    
    
    // Variables
    
    var effect:UIVisualEffect!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Parallax Effect
        self.ApplyMotionEffectsforViewDidLoad()
        
        
        //Hide Navigation Bar Controller
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        // Dismiss Keyboard
        self.hideKeyboardWhenTappedAround()
        
        // Visual Effect
        effect = VisualEffect.effect
        VisualEffect.effect = nil
        self.animateIn()
        
        // Cornerradius
        InformationView.layer.cornerRadius = 5
        
        
    }
    

    
    //Dismiss ViewAction
    
    
    @IBAction func RemoveInformationView(_ sender: Any) {
        
        self.animateOut()
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
    
    
        if self.RegisterEmailTextField.text == "" || self.RegisterPasswordTextField.text == ""
        {
            let alertController = UIAlertController(title: "Oops!", message: "Please enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            FIRAuth.auth()?.createUser(withEmail: self.RegisterEmailTextField.text!, password: self.RegisterPasswordTextField.text!) { (user, error) in
                
                if error == nil
                {
                    
                    
                    let alert = UIAlertController(title: "Erfolgreich Registriert", message: "Sie werden nun automatisch eingeloggt", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                        let viewControllerYouWantToPresent = self.storyboard?.instantiateViewController(withIdentifier: "LoginPage")
                        self.present(viewControllerYouWantToPresent!, animated: true, completion: nil)
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                    
            
                    self.RegisterEmailTextField.text = ""
                    self.RegisterPasswordTextField.text = ""
                    
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
        applyMotionEffect(toView: background, magnitude: 5)
        applyMotionEffect(toView: Form, magnitude: -10)
        applyMotionEffect(toView: ZüriBild, magnitude: -10)
        applyMotionEffect(toView: RegisterPasswordTextField, magnitude: -10)
        applyMotionEffect(toView: RegisterEmailTextField, magnitude: -10)
        applyMotionEffect(toView: EmailLabel, magnitude: -10)
        applyMotionEffect(toView: PasswordLabel, magnitude: -10)
        applyMotionEffect(toView: RegisterButton, magnitude: -10)
        
    }





    
}
