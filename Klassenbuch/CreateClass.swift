//
//  CreateClass.swift
//  Klassenbuch
//
//  Created by Developing on 25.08.17.
//  Copyright © 2017 Hadorn Developing. All rights reserved.
//

import UIKit
import Firebase


class CreateClass: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    
    var SchuljahrString = String()
    var KlassenNamenString = String()
    var Klasse = String()
    var ref:FIRDatabaseReference?
    var handle : FIRDatabaseHandle?
    var myName = String()
    var myKlasse = String()
    var myEmail = String()
    var SemesterPicker = UIPickerView()
    
    
    @IBOutlet weak var SaveButton: UIBarButtonItem!
    
    @IBOutlet weak var KlassenNamenTextLabel: UITextField!
    @IBOutlet weak var SemesterTextField: UITextField!
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        
        print(myKlasse)
        KlassenNamenTextLabel.delegate = self
        Klasse = "\(KlassenNamenTextLabel.text!)\(SemesterTextField.text!)"
        
        // Picker Delegates & Datasource
        SemesterPicker.delegate = self
        SemesterPicker.dataSource = self
        SemesterTextField.delegate = self
        SemesterTextField.inputView = SemesterPicker
        //SchuljahrTextLabel.text = SchuljahrString
        
       // SemesterTextField.text  = ""
        //SemesterLabel?.numberOfLines = 0
        
        // Left Swipe
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .left
        
        view.addGestureRecognizer(edgePan)
        
        //Database Refrence Property
        ref = FIRDatabase.database().reference()
        self.hideKeyboardWhenTappedAround()
        //self.dismissKeyboard()
        SaveButton.isEnabled = false
    
    
    
    
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

    let Semester = ["HS 17-18","FS18","HS 18-19","FS19","HS 19-20"]

    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
     
        
        return Semester.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
            
            SemesterTextField.text = Semester[row]
        
    
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return Semester[row]
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        
        if segue.identifier == "NewClassMembers" {
            
            let DestViewController = segue.destination as! AddClassMembers
            DestViewController.myClass = Klasse
            
        }
    
    
    
    
    }
    
    
    
    func getName(){
    
    
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        
        ref = FIRDatabase.database().reference()
        
       // handle = ref?.child("users").child("Schüler").child(uid!).observe(.value, with: { (snapshot) in
            
      //      self.ref?.child("users").child("Schüler").child(uid!).updateChildValues(["name": Namen])
            
   
        
        ref?.child("users").child("Schüler").child(uid!).child("email").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let item = snapshot.value as? String{
                self.myEmail = item
               
            }
        })

        
        ref?.child("users").child("Schüler").child(uid!).child("Klasse").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let item3 = snapshot.value as? String{
                self.myKlasse = item3
             
            }
        })
    }
    
    
    
    //Fund for Left Swipe
    
    func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        
        if recognizer.state == .recognized {
            self.performSegue(withIdentifier: "UnwindToOverview", sender: self)
        }
    }
    
    @IBAction func SaveClass(_ sender: Any) {
        
       
     
 
        
       Klasse = "\(KlassenNamenTextLabel.text!)\(SemesterTextField.text!)"
      
       self.ref?.child("users/Klassen").updateChildValues([self.Klasse : self.Klasse])
        
        
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid

        // Upload to Firebase
        //self.ref?.child("users/Klassen").childByAutoId().setValue(Klasse)
        
//        ref?.child("users").child("Schüler").child(uid!).child("name").observeSingleEvent(of: .value, with: { (snapshot) in
//            
//            if let item = snapshot.value as? String{
//                self.myName = item
//                
//                
//        self.ref?.child("users/Klassen").childByAutoId().setValue([self.Klasse : self.Klasse])
//                
//                
//            }
//        })
        
        
        
  
        
        self.ref?.child("users/Schüler").child(uid!).updateChildValues(["Klasse" : Klasse]) //setValue(["Klasse": Klasse])
       
        UserDefaults.standard.set(true, forKey: "StudenthasClass")
        UserDefaults.standard.synchronize()
        
        
        ref?.child("users").child("Schüler").child(uid!).child("name").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let item = snapshot.value as? String{
                self.myName = item
           
            self.ref?.child("KlassenMitglieder/\(self.Klasse)").updateChildValues([self.myName.lowercased() : self.myName.lowercased()])
           
                
              //  self.ref2?.child("KlassenMitglieder/\(self.myClass)")

            
            }
        })
        
        
        
        
        
        
        
        
        // Name scho ineglodet in array für nechst view mit klassemitglieder
        
      
        self.performSegue(withIdentifier: "NewClassMembers", sender: self)
        
    }
    
    
    // Save Button Enabled
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if (SemesterTextField.text?.isEmpty)! || (KlassenNamenTextLabel.text?.isEmpty)! {
            SaveButton.isEnabled = false
        } else {
            SaveButton.isEnabled = true
        }
    }

}

struct MyVariables {
    static var myfuckingklass = "hhh"
}
