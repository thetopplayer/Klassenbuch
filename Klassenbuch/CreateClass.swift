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
    
    @IBOutlet weak var KlassenNamenTextLabel: UITextField!
    @IBOutlet weak var SemesterLabel: UILabel!
   
        @IBOutlet weak var SemesterPicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        
        print(myKlasse)
        KlassenNamenTextLabel.delegate = self
        Klasse = "\(KlassenNamenTextLabel.text!)\(SemesterLabel.text!)"
        
        // Picker Delegates & Datasource
        SemesterPicker.delegate = self
        SemesterPicker.dataSource = self
        //SchuljahrTextLabel.text = SchuljahrString
        
        SemesterLabel.text  = ""
        SemesterLabel?.numberOfLines = 0
        
        // Left Swipe
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .left
        
        view.addGestureRecognizer(edgePan)
        
        //Database Refrence Property
        ref = FIRDatabase.database().reference()
        self.hideKeyboardWhenTappedAround()
        //self.dismissKeyboard()
        
    
    
    
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    let Semester = ["HS 17-18","FS18","HS 18-19","FS19","HS 19-20"]

    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
     
        
        return Semester.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
            
            SemesterLabel.text = Semester[row]
        
    
        
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
            
      ref?.child("users").child("Schüler").child(uid!).child("name").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let item = snapshot.value as? String{
                self.myName = item
            }
        })
        
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
        
       
     
 
        
       Klasse = "\(KlassenNamenTextLabel.text!)\(SemesterLabel.text!)"
      
        
        
        
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid

         // Upload to Firebase
        self.ref?.child("users/Klassen").childByAutoId().setValue(Klasse)
        
        self.ref?.child("users/Schüler").child(uid!).updateChildValues(["Klasse" : Klasse]) //setValue(["Klasse": Klasse])
        self.ref?.child("KlassenMitglieder/\(Klasse)").childByAutoId().setValue(myName)
        
        // Name scho ineglodet in array für nechst view mit klassemitglieder
        
      
        self.performSegue(withIdentifier: "NewClassMembers", sender: self)
        
    }
    
    
   

}

struct MyVariables {
    static var myfuckingklass = "hhh"
}
