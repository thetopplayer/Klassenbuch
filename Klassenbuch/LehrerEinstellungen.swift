//
//  LehrerEinstellungen.swift
//  Klassenbuch
//
//  Created by Developing on 27.08.17.
//  Copyright © 2017 Hadorn Developing. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

class LehrerEinstellungen: UITableViewController, UNUserNotificationCenterDelegate {

    @IBOutlet weak var TeacherReminderSwitch: UISwitch!
    
    // Variables
    let defaults = UserDefaults.standard
    let LehrerReminderString = "ReminderString"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let fixreminderString = defaults.value(forKey: LehrerReminderString){
            TeacherReminderSwitch.isOn = fixreminderString as! Bool
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    @IBAction func LogOut(_ sender: Any) {
       
        let actionSheet = UIAlertController(title: "", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let titleFont = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 20.0)!]
        
        let titleAttrString = NSMutableAttributedString(string: "Willst du dich wirklich abmelden?", attributes: titleFont)
        
        
        actionSheet.setValue(titleAttrString, forKey: "attributedTitle")
        
        
        
        
        let logoutAction = UIAlertAction(title: "Abmelden", style: UIAlertActionStyle.destructive) { (alert:UIAlertAction) -> Void in
            FIRAnalytics.logEvent(withName: "User logged out", parameters: nil)
            try! FIRAuth.auth()!.signOut()
            if let storyboard = self.storyboard {
                UserDefaults.standard.set(false, forKey: "isTeacher")
                UserDefaults.standard.synchronize()
                
                let vc = storyboard.instantiateViewController(withIdentifier: "LoginNavigationVC") as! UINavigationController
                self.present(vc, animated: false, completion: nil)
                
                print("Logout Pressed")
            }}
        
        let cancelAction = UIAlertAction(title: "Abbrechen", style: UIAlertActionStyle.cancel) { (alert:UIAlertAction) -> Void in
            print("Cancel Pressed")
        }
        
        actionSheet.addAction(logoutAction)
        
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    
    @IBAction func ReminderSwitch(_ sender: UISwitch) {
        
        if TeacherReminderSwitch.isOn == true {
            
            UserDefaults.standard.set(true, forKey: "TeacherReminders")
            UserDefaults.standard.synchronize()
            
        } else if TeacherReminderSwitch.isOn == false {
            
            let actionSheet = UIAlertController(title: "", message: "Alle Ihre bisherigen Reminders werden somit gelöscht!", preferredStyle: UIAlertControllerStyle.actionSheet)
            
            let titleFont = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 20.0)!]
            
            let titleAttrString = NSMutableAttributedString(string: "Wollen Sie wirklich keine Errinerungen mehr erhalten?", attributes: titleFont)
            
            actionSheet.setValue(titleAttrString, forKey: "attributedTitle")
            
            let Action1 = UIAlertAction(title: "Ja", style: UIAlertActionStyle.destructive) { (alert:UIAlertAction) -> Void in
                
                // UserDefaults für Button off
                UserDefaults.standard.set(false, forKey: "TeacherReminders")
                UserDefaults.standard.synchronize()
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                
            }
            
            let cancelAction = UIAlertAction(title: "Abbrechen", style: UIAlertActionStyle.cancel) { (alert:UIAlertAction) -> Void in
                self.TeacherReminderSwitch.isOn = true
                // UserDefaults
                UserDefaults.standard.set(true, forKey: "TeacherReminders")
                UserDefaults.standard.synchronize()
            }
            
            actionSheet.addAction(Action1)
            
            actionSheet.addAction(cancelAction)
            
            self.present(actionSheet, animated: true, completion: nil)
            
            
        }
        
        
        defaults.set(sender.isOn, forKey: LehrerReminderString)

    }

    @IBAction func cancelUserinfo (_ segue:UIStoryboardSegue) {
    }
    }
