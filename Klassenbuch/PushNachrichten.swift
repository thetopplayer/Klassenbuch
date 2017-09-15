//
//  PushNachrichten.swift
//  Klassenbuch
//
//  Created by Developing on 17.04.17.
//  Copyright © 2017 Hadorn Developing. All rights reserved.
//

import UIKit
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import UserNotifications

class PushNachrichten: UITableViewController {

    // Outlets
    @IBOutlet weak var SwitchAllgemeineInformationen: UISwitch!
    @IBOutlet weak var Switch1Klasse: UISwitch!
    @IBOutlet weak var Switch2Klasse: UISwitch!
    @IBOutlet weak var Switch3Klasse: UISwitch!
    @IBOutlet weak var Switch4Klasse: UISwitch!
    @IBOutlet weak var Switch5Klasse: UISwitch!
    @IBOutlet weak var Switch6Klasse: UISwitch!
    @IBOutlet weak var SwitchFreiwilligeAnlässe: UISwitch!
    @IBOutlet weak var ReminderSwitch: UISwitch!
    
    // Variables
    let defaults = UserDefaults.standard
    
    let ErsteKlasse =   "ErsteKlasse"
    let ZweiteKlasse =   "ZweiteKlasse"
    let DritteKlasse =   "DritteKlasse"
    let VierteKlasse =   "VierteKlasse"
    let fuenfteKlasse =   "FuenfteKlasse"
    let sechsteKlasse =   "SechsteKlasse"
   
    let allgemeineInfos =   "AllgemeineInfos"
    let freiwilligeAnlaesse = "freiwilligeAnlaesse"
    let reminderString = "ReminderString"
    
    
    var RowSectionArray = [["1"],["1","1","1","1","1","1","1","1"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let fixallgemeininfos = defaults.value(forKey: allgemeineInfos){
        SwitchAllgemeineInformationen.isOn = fixallgemeininfos as! Bool
        }
        if let fixErsteKlasse = defaults.value(forKey: ErsteKlasse){
            Switch1Klasse.isOn = fixErsteKlasse as! Bool
        }
        if let fixZweiteKlasse = defaults.value(forKey: ZweiteKlasse){
            Switch2Klasse.isOn = fixZweiteKlasse as! Bool
        }
        if let fixDritteKlasse = defaults.value(forKey: DritteKlasse){
            Switch3Klasse.isOn = fixDritteKlasse as! Bool
        }
        if let fixVierteKlasse = defaults.value(forKey: VierteKlasse){
            Switch4Klasse.isOn = fixVierteKlasse as! Bool
        }
        if let fixfuenfteKlasse = defaults.value(forKey: fuenfteKlasse){
            Switch5Klasse.isOn = fixfuenfteKlasse as! Bool
        }
        if let fixsechsteKlasse = defaults.value(forKey: sechsteKlasse){
            Switch6Klasse.isOn = fixsechsteKlasse as! Bool
        }
        if let fixfreiwilligeAnlaesse = defaults.value(forKey: freiwilligeAnlaesse){
            SwitchFreiwilligeAnlässe.isOn = fixfreiwilligeAnlaesse as! Bool
        }
        if let fixreminderString = defaults.value(forKey: reminderString){
        ReminderSwitch.isOn = fixreminderString as! Bool
        }
        
        // Left Swipe
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .left
        
        view.addGestureRecognizer(edgePan)
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    override func viewDidAppear(_ animated: Bool) {
        self.noReminderinSettings()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.RowSectionArray[section].count
    
    }


    //Switch Actions
    
    @IBAction func AllgemineInformationen(_ sender: UISwitch) {
        
          defaults.set(sender.isOn, forKey: allgemeineInfos)
        if SwitchAllgemeineInformationen.isOn {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            FIRMessaging.messaging().subscribe(toTopic: "/topics/Allgemeine-Informationen")
                print("subscribed to Allgemeine-Informationen")
                FIRAnalytics.logEvent(withName: "subscribed_to_Allgemeine-Informationen", parameters: nil)
            }
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            FIRMessaging.messaging().unsubscribe(fromTopic: "/topics/Allgemeine-Informationen")
            FIRAnalytics.logEvent(withName: "unsubscribed_to_Allgemeine-Informationen", parameters: nil)
            }}
        
    }
    
    
    @IBAction func ErsteKlasse(_ sender: UISwitch) {
       defaults.set(sender.isOn, forKey: ErsteKlasse)
       
        if Switch1Klasse.isOn {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        FIRMessaging.messaging().subscribe(toTopic: "/topics/Klasse1")
                print("subscribed to Klasse1")
                     FIRAnalytics.logEvent(withName: "subscribed_to_Klasse1", parameters: nil)
            }
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
       FIRMessaging.messaging().unsubscribe(fromTopic: "/topics/Klasse1")
                FIRAnalytics.logEvent(withName: "unsubscribed_to_Klasse1", parameters: nil)
            }}
    }
    
    
    @IBAction func ZweiteKlasse(_ sender: UISwitch) {
         defaults.set(sender.isOn, forKey: ZweiteKlasse)
        if Switch2Klasse.isOn {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
             FIRMessaging.messaging().subscribe(toTopic: "/topics/Klasse2")
                print("subscribed to Klasse2")
                FIRAnalytics.logEvent(withName: "subscribed_to_Klasse2", parameters: nil)
            }  }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            FIRMessaging.messaging().unsubscribe(fromTopic: "/topics/Klasse2")
                FIRAnalytics.logEvent(withName: "unsubscribed_to_Klasse2", parameters: nil)
            }}
    }
    @IBAction func DritteKlasse(_ sender: UISwitch) {
         defaults.set(sender.isOn, forKey: DritteKlasse)
        if Switch3Klasse.isOn {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
          FIRMessaging.messaging().subscribe(toTopic: "/topics/Klasse3")
                FIRAnalytics.logEvent(withName: "subscribed_to_Klasse3", parameters: nil)
                print("subscribed to Klasse3")
            }}else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
           FIRMessaging.messaging().unsubscribe(fromTopic: "/topics/Klasse3")
                FIRAnalytics.logEvent(withName: "unsubscribed_to_Klasse3", parameters: nil)
            }}
    }
    @IBAction func VierteKlasse(_ sender: UISwitch) {
         defaults.set(sender.isOn, forKey: VierteKlasse)
        if Switch4Klasse.isOn {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
             FIRMessaging.messaging().subscribe(toTopic: "/topics/Klasse4")
                print("subscribed to Klasse4")
                FIRAnalytics.logEvent(withName: "subscribed_to_Klasse4", parameters: nil)
            }}else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            FIRMessaging.messaging().unsubscribe(fromTopic: "/topics/Klasse4")
                FIRAnalytics.logEvent(withName: "unsubscribed_to_Klasse4", parameters: nil)
            }}
    }
    @IBAction func fuenfteKlasse(_ sender: UISwitch) {
        
        defaults.set(sender.isOn, forKey: fuenfteKlasse)
        
        if Switch5Klasse.isOn {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
             FIRMessaging.messaging().subscribe(toTopic: "/topics/Klasse5")
                print("subscribed to Klasse5")
                FIRAnalytics.logEvent(withName: "subscribed_to_Klasse5", parameters: nil)
            } }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            FIRMessaging.messaging().unsubscribe(fromTopic: "/topics/Klasse5")
            FIRAnalytics.logEvent(withName: "unsubscribed_to_Klasse5", parameters: nil)
        }
        }}
    @IBAction func sechsteKlasse(_ sender: UISwitch) {
         defaults.set(sender.isOn, forKey: sechsteKlasse)
        if Switch6Klasse.isOn {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
             FIRMessaging.messaging().subscribe(toTopic: "/topics/Klasse6")
                       print("subscribed to Klasse6")
                FIRAnalytics.logEvent(withName: "subscribed_to_Klasse6", parameters: nil)
            } }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            FIRMessaging.messaging().unsubscribe(fromTopic: "/topics/Klasse6")
                FIRAnalytics.logEvent(withName: "unsubscribed_to_Klasse6", parameters: nil)
            }}
    }
    @IBAction func freiwilligeAnlaesse(_ sender: UISwitch) {
         defaults.set(sender.isOn, forKey: freiwilligeAnlaesse)
        if SwitchFreiwilligeAnlässe.isOn {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            FIRMessaging.messaging().subscribe(toTopic: "/topics/freiwillig")
                print("subscribed to freiwillige Anlässe")
                FIRAnalytics.logEvent(withName: "subscribed_to_freiwillige Anlässe", parameters: nil)
            }}else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            FIRMessaging.messaging().unsubscribe(fromTopic: "/topics/freiwillig")
            FIRAnalytics.logEvent(withName: "unsubscribed_to_freiwillige Anlässe", parameters: nil)
            }}
    }
    //Fund for Left Swipe
    
    @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        
        if recognizer.state == .recognized {
            self.performSegue(withIdentifier: "unwindPushes", sender: self)
        }
    }

//    @IBAction func StopAllReminders(_ sender: Any) {
//        
//        
//        let actionSheet = UIAlertController(title: "", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
//        
//        let titleFont = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 20.0)!]
//        
//        let titleAttrString = NSMutableAttributedString(string: "Willst du wirklich deine Absenzen Errinerungen löschen?", attributes: titleFont)
//        
//        
//        actionSheet.setValue(titleAttrString, forKey: "attributedTitle")
//        
//        
//        
//        
//        let logoutAction = UIAlertAction(title: "Reminders löschen", style: UIAlertActionStyle.destructive) { (alert:UIAlertAction) -> Void in
//           UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
//        }
//        
//        let cancelAction = UIAlertAction(title: "Abbrechen", style: UIAlertActionStyle.cancel) { (alert:UIAlertAction) -> Void in
//            print("Cancel Pressed")
//        }
//        
//        actionSheet.addAction(logoutAction)
//        
//        actionSheet.addAction(cancelAction)
//        
//        self.present(actionSheet, animated: true, completion: nil)
//    }
    
    
    
    
    @IBAction func ReminderSwitch(_ sender: UISwitch) {

       
        if ReminderSwitch.isOn == true {
           
            UserDefaults.standard.set(true, forKey: "Reminders")
            UserDefaults.standard.synchronize()
        
        } else if ReminderSwitch.isOn == false {
        
            let actionSheet = UIAlertController(title: "Willst du dich wirklich keine Errinerungen erhalten?", message: "Alle deine bisherigen Reminders werden somit gelöscht!", preferredStyle: UIAlertControllerStyle.actionSheet)
            
//            let titleFont = [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Medium", size: 20.0)!]
            
//            let titleAttrString = NSMutableAttributedString(string: "", attributes: titleFont)
            
//            actionSheet.setValue(titleAttrString, forKey: "attributedTitle")
            
            let Action1 = UIAlertAction(title: "Ja", style: UIAlertActionStyle.destructive) { (alert:UIAlertAction) -> Void in
                
                // UserDefaults für Button off
                UserDefaults.standard.set(false, forKey: "Reminders")
                UserDefaults.standard.synchronize()
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                
            }
            
            let cancelAction = UIAlertAction(title: "Abbrechen", style: UIAlertActionStyle.cancel) { (alert:UIAlertAction) -> Void in
                self.ReminderSwitch.isOn = true
                // UserDefaults
                UserDefaults.standard.set(true, forKey: "Reminders")
                UserDefaults.standard.synchronize()
            }
            
            actionSheet.addAction(Action1)
            
            actionSheet.addAction(cancelAction)
            
            self.present(actionSheet, animated: true, completion: nil)

        
        }
        
        
                 defaults.set(sender.isOn, forKey: reminderString)
    }
    
    
    
    
    
    func noReminderinSettings(){
        
        
        let notificationType = UIApplication.shared.currentUserNotificationSettings!.types
        if notificationType == [] {
            
            print("notifications are NOT enabled")
            
            let alertController2 = UIAlertController(title: "Ooops", message: "Benachrichtigungen für dieses App sind nicht eingeschaltet", preferredStyle: .alert)
            
            alertController2.addAction(UIAlertAction(title: "Einstellungen", style: .default, handler: { (action: UIAlertAction!) in
                //Go to Settings
                
                self.gotoSettings()
                
            }))
            
            alertController2.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action: UIAlertAction!) in
                
                self.performSegue(withIdentifier: "unwindPushes", sender: nil)
            }))
            
            
            
            
            self.present(alertController2, animated: true, completion: nil)
            
            
        } else {
            
            
        }
        
    }
    
    // Go to Acknowledgements Function in Settings
    
    func gotoSettings() {
        
        print("Send to Settings")
        
        // THIS IS WHERE THE MAGIC HAPPENS!!!!
        
        if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
            UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
        }
    }

}
