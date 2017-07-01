//
//  Notes.swift
//  Klassenbuch
//
//  Created by Developing on 30.06.17.
//  Copyright © 2017 Hadorn Developing. All rights reserved.
//

import Foundation




/* Left Swipe
 let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
 edgePan.edges = .left
 view.addGestureRecognizer(edgePan)
 */
//Fund for Left Swipe

/* func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
 
 if recognizer.state == .recognized {
 self.performSegue(withIdentifier: "cancelRegistration", sender: nil)
 }
 }*/
//    func gotoOnboarding(){
//
//        // If Ok tapped check if user is sucessfully signed in
//        FIRAuth.auth()?.addStateDidChangeListener { auth, authuser in
//
//            if authuser != nil {
//
//                // There is a User, because the User registered He has to see the Onboarding
//
//                self.performSegue(withIdentifier: "ClassSetup", sender: self)
//
//            } else {
//
//                // No User is signed in. Show Alert View Controller
//
//                let failedAuthTest = UIAlertController(title: "Oops!", message: "Es lief etwas schief mit deiner Identifikation, bitte probiere es nochmals.", preferredStyle: .alert)
//
//                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                failedAuthTest.addAction(defaultAction)
//
//                self.present(failedAuthTest, animated: true, completion: nil)
//
//            }
//        }
//    }


//        self.LoginEmailTextField.isHidden = true
//        self.LoginPasswordTextField.isHidden = true
//        //self.BackgroundImage.isHidden = true
//        self.ZüriBild.isHidden = true
//        self.EmailLabel.isHidden = true
//        self.PasswordLabel.isHidden = true
//        self.LoginButton.isHidden = true
//        self.EyeButton.isHidden = true
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
//        self.Form.isHidden = true}
//        self.Stack1.isHidden = true
//        self.Stack2.isHidden = true



//        // Show the Rest
//        self.BacktoLoginfromPR.isHidden = false
//        self.Form2.isHidden = false
//        self.EmailLabel2.isHidden = false
//        self.RestorePasswordTextField.isHidden = false
//        self.ZüriBild2.isHidden = false
//        self.RestorePasswordButton.isHidden = false


//@IBAction func BacktoLogin(_ sender: Any) {
//        self.LoginEmailTextField.isHidden = false
//        self.LoginPasswordTextField.isHidden = false
//        //self.BackgroundImage.isHidden = true
//        self.ZüriBild.isHidden = false
//        self.EmailLabel.isHidden = false
//        self.PasswordLabel.isHidden = false
//        self.LoginButton.isHidden = false
//        self.EyeButton.isHidden = false
//        self.Form.isHidden = false
//        self.Stack1.isHidden = false
//        self.Stack2.isHidden = false


//        // Show the Rest
//        self.BacktoLoginfromPR.isHidden = true
//        self.Form2.isHidden = true
//        self.EmailLabel2.isHidden = true
//        self.RestorePasswordTextField.isHidden = true
//        self.ZüriBild2.isHidden = true
//        self.RestorePasswordButton.isHidden = true




//   }



//    // Starting Information Animation
//
//    func animateIn() {
//        self.view.addSubview(Form)
//        //InformationView.center = self.view.center
//
//        Form.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
//        //InformationView.alpha = 0
//
//        UIView.animate(withDuration: 0.4) {
//            //self.VisualEffect.effect = self.effect
//            //self.InformationView.alpha = 1
//            self.Form.transform = CGAffineTransform.identity
//            //self.VisualEffect.isUserInteractionEnabled = true
//        }
//    }
//
//    //Ending Information Animation
//
//    func animateOut () {
//        UIView.animate(withDuration: 0.4, animations: {
//            self.Form.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
//            //self.InformationView.alpha = 0
//            //self.VisualEffect.isUserInteractionEnabled = false
//            //self.VisualEffect.effect = nil
//
//        }) { (success:Bool) in
//            self.Form.removeFromSuperview()
//        }
//    }






//
//                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (Bool, error) in
//                    if let error = error {
//                print(error)
//                    }
//            }
//
//
//
//
//                // Alert Controller
//                let alertController = UIAlertController(title: "", message: "Um einen Tag vor der Frist informiert zu werden klicke auf Errinere mich!", preferredStyle:UIAlertControllerStyle.actionSheet)
//
//               // let AbsenzenSheet = UIAlertController(title: "", message: "\(String(describing: PersonTitle)) du musst deine Absenz vom \(String(describing: sectionTitle!)) bis am \(futureDateinString) unterschreiben lassen und abgeben.", preferredStyle: UIAlertControllerStyle.actionSheet)
//
//                let titleFont = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 20.0)!]
//
//                let titleAttrString = NSMutableAttributedString(string: "Errinerung einrichten!", attributes: titleFont)
//
//                alertController.setValue(titleAttrString, forKey: "attributedTitle")
//                alertController.view.tintColor = UIColor.black
//
//
//
//                alertController.addAction(UIAlertAction(title: "Errinere mich!", style: .default, handler: { (action: UIAlertAction!) in
//
//
//                // Content
//                let content = UNMutableNotificationContent()
//                content.title = "Absenz Errinerung"
//                content.body = "\(String(describing: PersonTitle)), Morgen ist die Absenz vom \(String(describing: sectionTitle!)) abzugeben."
//                    // content.categoryIdentifier = "myCategory"
//                content.sound = UNNotificationSound.default()
//                content.badge = 1
//
//
//
//
//                let mydate = ((NSDate() as Date) as Date) + (futureDateinDate?.timeIntervalSince(Date()))! - 36000 - 86400
//
//                let dateComponent = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: mydate)
//                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
//
//
//                // For Developing only
//                //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//
//
//                let request = UNNotificationRequest(identifier: "Absenzen Timer Fertig", content: content, trigger: trigger)
//
//                UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
//                    if let error = error{
//                    print("Could not create Local notification", error)
//                    }else if let date = trigger.nextTriggerDate(){
//                    print("Next notification date:", date)
//                    print("Errinierung an")
//                    }
//                    }
//                        )
//
//
//                    }))
//
//                    alertController.addAction(UIAlertAction(title: "Alle Errinerungen stoppen!", style: .destructive, handler: { (action: UIAlertAction!) in
//                    print("Alle Reminder stoppen Tapped")
//
//                        // Stop all reminders
//                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
//
//                    }))
//
//
//                alertController.addAction(UIAlertAction(title: "Abbrechen", style: .cancel, handler: { (action: UIAlertAction!) in
//                        print("Abbrechen Tapped")
//                            }))
//
//                self.present(alertController, animated: true, completion: nil)
//UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)



// reminder = Reminder(name: name, time: triggerDate, notification: content)



















//                let mydate = ((NSDate() as Date) as Date) + (futureDateinDate?.timeIntervalSince(Date()))! - 36000 - 86400
//
//                let dateComponent = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: mydate)
//                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
//
//
//                // For Developing only
//                //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//
//
//                let request = UNNotificationRequest(identifier: "Absenzen Timer Fertig", content: content, trigger: trigger)
//
//                UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
//                    if let error = error{
//                    print("Could not create Local notification", error)
//                    }else if let date = trigger.nextTriggerDate(){
//                    print("Next notification date:", date)
//                    print("Errinierung an")
//                    }
//                    }
//                        )
//
//
//                    }))
