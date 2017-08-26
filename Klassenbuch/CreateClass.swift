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
    
    
    @IBOutlet weak var KlassenNamenTextLabel: UITextField!
    @IBOutlet weak var SemesterLabel: UILabel!
   
        @IBOutlet weak var SemesterPicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        KlassenNamenTextLabel.delegate = self
        
        
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
    
    
    
    
    
    
    
    
    
    //Fund for Left Swipe
    
    func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        
        if recognizer.state == .recognized {
            self.performSegue(withIdentifier: "UnwindToOverview", sender: self)
        }
    }
    
    @IBAction func SaveClass(_ sender: Any) {
        
       
        
        
  
        
       Klasse = "\(KlassenNamenTextLabel.text!)\(SemesterLabel.text!)"
        

     

         // Upload to Firebase
        self.ref?.child("users/Klassen").childByAutoId().setValue(Klasse)
      
        self.performSegue(withIdentifier: "GoBAcktoClassSelection", sender: self)
        
    }
    
    
    

}
