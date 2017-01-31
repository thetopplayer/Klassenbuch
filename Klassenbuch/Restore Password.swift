//
//  Restore Password.swift
//  Klassenbuch
//
//  Created by Developing on 29.01.17.
//  Copyright © 2017 Hadorn Developing. All rights reserved.
//

import UIKit
import Firebase

class Restore_Password: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var Form: UIImageView!
    @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var RestorePasswordTextField: AuthTextField!
    @IBOutlet weak var ZüriBild: UIImageView!
    @IBOutlet weak var RestorePasswordButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Parallax Effect 
        self.ApplyMotionEffectsforViewDidLoad()
        
        // Hide Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        //Hide Keyboard
        self.hideKeyboardWhenTappedAround()

        // TextFieldDelegates
        RestorePasswordTextField.delegate = self

           }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    
    // Next Button Klicked Textfield new First Responder
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == RestorePasswordTextField{
            
            RestorePasswordTextField.resignFirstResponder()
        }
        return true
    }

    
    
    @IBAction func restorePassword(sender: AnyObject)
    {
        if self.RestorePasswordTextField.text == ""
        {
            let alertController = UIAlertController(title: "Oops!", message: "Please enter an email.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            FIRAuth.auth()?.sendPasswordReset(withEmail: self.RestorePasswordTextField.text!, completion: { (error) in
                
                var title = ""
                var message = ""
                
                if error != nil
                {
                    title = "Oops!"
                    message = (error?.localizedDescription)!
                }
                else
                {
                    title = "Passwort Erfolgreich zurückgesetzt!"
                    message = "Sie werden in Kürze eine Email erhalten mit Anweisungen wie Sie ihr Passwort erneuern können."
                    self.RestorePasswordTextField.text = ""
                }
                
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            })
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
        applyMotionEffect(toView: RestorePasswordTextField, magnitude: -10)
        applyMotionEffect(toView: EmailLabel, magnitude: -10)
        applyMotionEffect(toView: RestorePasswordButton, magnitude: -10)
        
    }

}
