//
//  ChangeStatisticsManually.swift
//  Klassenbuch
//
//  Created by Developing on 08.09.17.
//  Copyright © 2017 Hadorn Developing. All rights reserved.
//

import UIKit
import Firebase

class ChangeStatisticsManually: UITableViewController, UITextFieldDelegate {

    //Outlets
    @IBOutlet weak var EntschuldigtTextField: UITextField!
    @IBOutlet weak var UnentschuldigtTextField: UITextField!
    @IBOutlet weak var OffenTextField: UITextField!
    @IBOutlet weak var GesamtTextField: UITextField!
    @IBOutlet weak var Header: UINavigationItem!
    @IBOutlet weak var SpeichernBtn: UIBarButtonItem!
    
    // Variables
    var Name = String()
    var Entschudigt = String()
    var Unentschudigt = String()
    var Offen = String()
    var Gesamt = String()
    var myklasse = String()
    var ref:FIRDatabaseReference?
//    var getdataTimer1 : Timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        EntschuldigtTextField.delegate = self
        UnentschuldigtTextField.delegate = self
        OffenTextField.delegate = self
        GesamtTextField.delegate = self
        
        EntschuldigtTextField.keyboardType = .numberPad
        UnentschuldigtTextField.keyboardType = .numberPad
        OffenTextField.keyboardType = .numberPad
        GesamtTextField.keyboardType = .numberPad
        
        Header.title = Name
        
        EntschuldigtTextField.text = Entschudigt
        UnentschuldigtTextField.text = Unentschudigt
        OffenTextField.text = Offen
        GesamtTextField.text = Gesamt
       
        self.ref = FIRDatabase.database().reference()
    }

    @IBAction func Speichern(_ sender: Any) {
        
        checkforEmptyTF()
     
        // Write to Firebase
        
        
        posttoFirebase()
      performSegue(withIdentifier: "DetailStatisikSegue", sender: nil)
//       getdataTimer1 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(LehrerStatistiken.getData) , userInfo: nil, repeats: true) 
        
    }
    func posttoFirebase(){
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        self.ref = FIRDatabase.database().reference()
        self.ref?.child("users").child("Lehrer").child(uid!).child("Klasse").observe(.value, with: { (snapshot) in
            
            
            if let item1 = snapshot.value as? String{
                
                
                self.myklasse = item1
 

                        self.ref!.child("Statistiken").child(self.myklasse).child(self.Name).updateChildValues(["AAnzahlStunden" : Int(self.GesamtTextField.text!)!,"AAbsenzenOffen" : Int(self.OffenTextField.text!)!,"AAbsenzenentschuldigt" : Int(self.EntschuldigtTextField.text!)!, "AAbsenzenunentschuldigt" : Int(self.UnentschuldigtTextField.text!)!])
                    }
                    
                    
                    
                })}
    

    func checkforEmptyTF(){
    
        if EntschuldigtTextField.text!.isEmpty == true || UnentschuldigtTextField.text!.isEmpty == true  || OffenTextField.text!.isEmpty == true  || GesamtTextField.text!.isEmpty == true {
            SpeichernBtn.isEnabled = false
        } else {
        SpeichernBtn.isEnabled = true
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
        return 4
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DetailStatisikSegue"{
            let DestViewController = segue.destination as! LehrerTabBar
            
                DestViewController.Counter = 2
            
        }

    
    }
   
}
