//
//  KlassenUserInfo.swift
//  Klassenbuch
//
//  Created by Developing on 26.08.17.
//  Copyright © 2017 Hadorn Developing. All rights reserved.
//

import UIKit
import Firebase

class KlassenUserInfo: UITableViewController {

    // Variables
    var handle : FIRDatabaseHandle?
    var ref: FIRDatabaseReference?
    var myKlasse = String()
    let defaults = UserDefaults.standard
    let allgemeineInfos =   "AllgemeineInfos"
    var myName = String()
    
    //Outlets
    @IBOutlet weak var KlassenLabel: UILabel!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var KlassenlehrerLabel: UILabel!
    @IBOutlet weak var KlassenLehrerCell: UITableViewCell!
    @IBOutlet weak var KlassenMitgliederCell: UITableViewCell!
    @IBOutlet weak var KlassenLehrerLabel: UILabel!
    @IBOutlet weak var LehrerModusSwitch: UISwitch!
    @IBOutlet weak var LehrerModusCell: UITableViewCell!
    @IBOutlet weak var AdminLabel: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        
//        let name = getName(UID: uid!)
//        print("\(name)akusdhahdfgjhasdgfjsaf")

        self.checkforAdmin()
        self.getInfos()
        KlassenLabel.numberOfLines = 0
        NameLabel.numberOfLines = 0
        EmailLabel.numberOfLines = 0

        if let fixallgemeininfos = defaults.value(forKey: allgemeineInfos){
            LehrerModusSwitch.isOn = fixallgemeininfos as! Bool
        }
     
        
  

        // Left Swipe
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .left
        
        view.addGestureRecognizer(edgePan)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        
        
        ref?.child("users").child("Schüler").child(uid!).child("Admin").observe(.value, with: { (snapshot) in
            
            if snapshot.value as? String == "true" {
                
                
                //                UserDefaults.standard.set(true, forKey: "isAdmin")
                //                UserDefaults.standard.synchronize()
                print("is admin2")
                self.NameLabel.textColor = UIColor.green
                self.KlassenLehrerCell.isUserInteractionEnabled = true
                self.KlassenMitgliederCell.isUserInteractionEnabled = true
                self.LehrerModusSwitch.isUserInteractionEnabled = true
                
                
            }
        })
        

        
        
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
        return 6
    }

    
    
    func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        
        if recognizer.state == .recognized {
            self.performSegue(withIdentifier: "backtotonfo", sender: self)
            
        }
    }
    
    
    
    
    @IBAction func LehrerSwitchChanged(_ sender: UISwitch) {
        
        defaults.set(sender.isOn, forKey: allgemeineInfos)
        
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        
        if LehrerModusSwitch.isOn == true {
        
       KlassenLehrerCell.isUserInteractionEnabled = true
           
            self.ref?.child("users").child("Schüler").child(uid!).child("Klasse").observe(.value, with: { (snapshot) in
                
                
                if let item3 = snapshot.value as? String{
                    
                    
                    self.myKlasse = item3
    
                    self.ref?.child("users").child("KlassenEinstellungen").child(self.myKlasse).updateChildValues(["HatKlassenLehrer": true])
                }})
            
        } else if LehrerModusSwitch.isOn == false {
        
      KlassenLehrerCell.isUserInteractionEnabled = false
            
            self.ref?.child("users").child("Schüler").child(uid!).child("Klasse").observe(.value, with: { (snapshot) in
                
                
                if let item3 = snapshot.value as? String{
                    
                    
                    self.myKlasse = item3
                    
                    self.ref?.child("users").child("KlassenEinstellungen").child(self.myKlasse).updateChildValues(["HatKlassenLehrer": false])
                }})
        
        }
        
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if  indexPath.row == 3 {
//        
//        self.performSegue(withIdentifier: "TheIdentifierSegue", sender: self)
//        
//        }
//    }

    func checkforAdmin(){
        
    
        
        
        
//        if UserDefaults.standard.bool(forKey: "isAdmin") == true {
//        
//            print("isadmin")
//          
//        
//        } else if UserDefaults.standard.bool(forKey: "isAdmin") == false {
//        
//           
//            print("isn'tadmin")
//        }
        
    
    }
    
    
    
    func getInfos(){
       
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        
        ref = FIRDatabase.database().reference()
        handle = ref?.child("users").child("Schüler").child(uid!).child("Klasse").observe(.value, with: { (snapshot) in
            
            
            if let MeineKlasse = snapshot.value as? String{
                
                
               self.KlassenLabel.text = MeineKlasse
                self.myKlasse = MeineKlasse
               
                
                
                
                
                
           
                self.ref?.child("users").child("KlassenEinstellungen").child(MeineKlasse).child("KlassenLehrer").observe(.value, with: { (snapshot) in
                    
                    
                    if let item3 = snapshot.value as? String{
                        
                        
                        self.KlassenLehrerLabel.text = item3
                        
                    }
                }
                )
               
                
                
            }
        }
            
            
        )
        
        ref = FIRDatabase.database().reference()
        handle = ref?.child("users").child("Schüler").child(uid!).child("email").observe(.value, with: { (snapshot) in
            
            
            if let item2 = snapshot.value as? String{
                
                
                self.EmailLabel.text = item2
              
                
            }
        }
            
            
        )
        
        

        
        ref = FIRDatabase.database().reference()
        handle = ref?.child("users").child("Schüler").child(uid!).child("name").observe(.value, with: { (snapshot) in
            
            
            if let item3 = snapshot.value as? String{
                
                
                self.NameLabel.text = item3
                self.myName = item3
                
               self.ref?.child("users").child("Schüler").child(uid!).child("Klasse").observe(.value, with: { (snapshot) in
                    
                    
                    if let MeineKlasse = snapshot.value as? String{
                        
                        
                        self.KlassenLabel.text = MeineKlasse
                        self.myKlasse = MeineKlasse
                        
                        
                        
                        self.ref?.child("users").child("KlassenEinstellungen").child(MeineKlasse).child("Admin").observe(.value, with: { (snapshot) in
                            
                            if snapshot.hasChild(self.myName){
                       
                                self.ref?.child("users").child("Schüler").child(uid!).updateChildValues(["Admin": "true"])
                            }
                            else {
                            
                            print("not admin !!!!!!!!!")
                            self.ref?.child("users").child("Schüler").child(uid!).updateChildValues(["Admin": "false"])
                            
                            }
                        })
                    }})
                }
                }
            )
        
        ref = FIRDatabase.database().reference()
        handle = ref?.child("users").child("Schüler").child(uid!).child("Admin").observe(.value, with: { (snapshot) in
            
            
            if snapshot.value as? String == "true" {
                
                
                self.NameLabel.textColor = UIColor.green
                
            }
        }
            
            
        )
        
      
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//    let DestViewController = segue.destination as! AddClassMembers
//        
//        if segue.identifier == ""{
//        
//            DestViewController.identifier = "AlreadyLoggedIn"
//        
//        }
    }
    
    @IBAction func backfromTeacherselection (_ segue:UIStoryboardSegue) {
    }
    @IBAction func backfromStudentselection (_ segue:UIStoryboardSegue) {
    }
    
    
    
//    
//    func getName(UID: String) -> String{
// 
//        ref = FIRDatabase.database().reference()
//        handle = ref?.child("users").child("Schüler").child(UID).child("name").observe(.value, with: { (snapshot) in
//      
//           return snapshot.value as? String
//         
//        }
//        )
//      return
//    }
//    

//    func getname (Klasse : inout String){
//        let user = FIRAuth.auth()?.currentUser
//        let uid = user?.uid
//        
//        ref = FIRDatabase.database().reference()
//        handle = ref?.child("users").child("KlassenEinstellungen").child(Klasse).child("Admin").observe(.value, with: { (snapshot) in
//            
//            
//            if let item3 = snapshot.value as? String{
//                
//                
//                self.NameLabel.text = item3
//                
//            }
//        }
//            
//            
//        )
//
//    
//    }
    
   }
