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
        
        // Left Swipe
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .left
        
        view.addGestureRecognizer(edgePan)
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 8
    }


    //Switch Actions
    
    @IBAction func AllgemineInformationen(_ sender: UISwitch) {
        
          defaults.set(sender.isOn, forKey: allgemeineInfos)
        if SwitchAllgemeineInformationen.isOn {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            FIRMessaging.messaging().subscribe(toTopic: "/topics/Allgemeine-Informationen")
                print("subscribed to Allgemeine-Informationen")}
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            FIRMessaging.messaging().unsubscribe(fromTopic: "/topics/Allgemeine-Informationen")
            }}
        
    }
    
    
    @IBAction func ErsteKlasse(_ sender: UISwitch) {
       defaults.set(sender.isOn, forKey: ErsteKlasse)
       
        if Switch1Klasse.isOn {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        FIRMessaging.messaging().subscribe(toTopic: "/topics/Klasse1")
                print("subscribed to Klasse1")
            }
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
       FIRMessaging.messaging().unsubscribe(fromTopic: "/topics/Klasse1")
            }}
    }
    
    
    @IBAction func ZweiteKlasse(_ sender: UISwitch) {
         defaults.set(sender.isOn, forKey: ZweiteKlasse)
        if Switch2Klasse.isOn {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
             FIRMessaging.messaging().subscribe(toTopic: "/topics/Klasse2")
                print("subscribed to Klasse2")
            }  }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            FIRMessaging.messaging().unsubscribe(fromTopic: "/topics/Klasse2")
            }}
    }
    @IBAction func DritteKlasse(_ sender: UISwitch) {
         defaults.set(sender.isOn, forKey: DritteKlasse)
        if Switch3Klasse.isOn {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
          FIRMessaging.messaging().subscribe(toTopic: "/topics/Klasse3")
                print("subscribed to Klasse3")
            }}else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
           FIRMessaging.messaging().unsubscribe(fromTopic: "/topics/Klasse3")
            }}
    }
    @IBAction func VierteKlasse(_ sender: UISwitch) {
         defaults.set(sender.isOn, forKey: VierteKlasse)
        if Switch4Klasse.isOn {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
             FIRMessaging.messaging().subscribe(toTopic: "/topics/Klasse4")
                print("subscribed to Klasse4")
            }}else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            FIRMessaging.messaging().unsubscribe(fromTopic: "/topics/Klasse4")
            }}
    }
    @IBAction func fuenfteKlasse(_ sender: UISwitch) {
         defaults.set(sender.isOn, forKey: fuenfteKlasse)
        if Switch5Klasse.isOn {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
             FIRMessaging.messaging().subscribe(toTopic: "/topics/Klasse5")
                print("subscribed to Klasse5")
            } }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            FIRMessaging.messaging().unsubscribe(fromTopic: "/topics/Klasse5")
        }
        }}
    @IBAction func sechsteKlasse(_ sender: UISwitch) {
         defaults.set(sender.isOn, forKey: sechsteKlasse)
        if Switch6Klasse.isOn {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
             FIRMessaging.messaging().subscribe(toTopic: "/topics/Klasse6")
                       print("subscribed to Klasse6")
            } }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            FIRMessaging.messaging().unsubscribe(fromTopic: "/topics/Klasse6")
            }}
    }
    @IBAction func freiwilligeAnlaesse(_ sender: UISwitch) {
         defaults.set(sender.isOn, forKey: freiwilligeAnlaesse)
        if SwitchFreiwilligeAnlässe.isOn {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            FIRMessaging.messaging().subscribe(toTopic: "/topics/freiwillig")
                print("subscribed to freiwillige Anlässe")
            }}else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            FIRMessaging.messaging().unsubscribe(fromTopic: "/topics/freiwillig")
            }}
    }
    //Fund for Left Swipe
    
    func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        
        if recognizer.state == .recognized {
            self.performSegue(withIdentifier: "unwindPushes", sender: self)
        }
    }

}
